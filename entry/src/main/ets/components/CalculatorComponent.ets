import { AnyUnit } from '../utils/UnitUtils';
import { LengthUnit } from '../utils/UnitEnums';
import { ConversionService } from '../services/ConversionService';
import { PreferencesService, PrefKeys, CatLastUsedResult } from '../services/PreferencesService';
import { FeedbackService } from '../services/FeedbackService';
import { ConversionRecord } from '../models/ConversionRecord';
import { CalcResultComponent } from './CalcResultComponent';
import { CalcButton } from './CalcButton';
import { UnitPickerDialog } from './UnitPickerDialog';

interface KeyDef {
  label: string;
  color?: ResourceColor;
}

interface PrefillData {
  category: string;
  fromUnit: string;
  toUnit: string;
  fromValue: string;
}

const KEYPAD_ROWS: KeyDef[][] = [
  [{ label: '7' }, { label: '8' }, { label: '9' }, { label: 'C', color: '#ffd6ca82' }],
  [{ label: '4' }, { label: '5' }, { label: '6' }, { label: 'DEL', color: '#ffe5d4a1' }],
  [{ label: '1' }, { label: '2' }, { label: '3' }, { label: '.' }],
  [{ label: '0' }]
];

@Component
export struct CalculatorComponent {
  private static readonly HISTORY_SAVE_DELAY_MS: number = 900;
  @Consume('NavPathStack') pathStack: NavPathStack;
  @State private fromNumber: string = '0';
  @State private toNumber: string = '0';
  @State private fromUnit: AnyUnit = LengthUnit.CENTIMETER;
  @State private toUnit: AnyUnit = LengthUnit.METER;
  @State private unitCategory: string = ConversionService.getCategories()[0];
  @State private favorite: boolean = false;
  @State private pickerTitle: string = '';
  @State private pickerRange: string[] = [];
  @State private pickerSelected: number = 0;
  @StorageLink(PrefKeys.FAVORITES_JSON) @Watch('refreshFavoriteFlag') private favoritesJson: string = '[]';
  @StorageLink(PrefKeys.PREFILL_RECORD) @Watch('onPrefillChanged') private prefillJson: string = '';
  private unitCategories: string[] = ConversionService.getCategories();
  private historySaveTimer: number = -1;
  private pickerOnConfirm: (index: number, value: string) => void = () => {
  };
  private pickerController: CustomDialogController = new CustomDialogController({
    builder: UnitPickerDialog({
      title: this.pickerTitle,
      range: this.pickerRange,
      selectedIndex: this.pickerSelected,
      onConfirm: (index: number, value: string) => this.pickerOnConfirm(index, value)
    }),
    alignment: DialogAlignment.Center,
    customStyle: true,
    autoCancel: true
  });

  aboutToAppear(): void {
    this.restoreLastUsed();
    this.refreshFavoriteFlag();
  }

  aboutToDisappear(): void {
    this.commitHistory();
  }

  private restoreLastUsed(): void {
    const savedCategory = PreferencesService.getLastCategory();
    const savedFrom = PreferencesService.getLastFromUnit() as AnyUnit;
    const savedTo = PreferencesService.getLastToUnit() as AnyUnit;

    if (!savedCategory || !this.unitCategories.includes(savedCategory)) {
      return;
    }
    const units = ConversionService.getUnitsForCategory(savedCategory);
    if (!units.includes(savedFrom) || !units.includes(savedTo)) {
      return;
    }
    this.unitCategory = savedCategory;
    this.fromUnit = savedFrom;
    this.toUnit = savedTo;
    this.recompute();
  }

  refreshFavoriteFlag(_propName?: string): void {
    if (!this.canCommitHistory()) {
      this.favorite = false;
      return;
    }
    const key = `${this.unitCategory}|${this.fromUnit}|${this.toUnit}|${this.fromNumber}|${this.toNumber}`;
    this.favorite = PreferencesService.isFavorite(key);
  }

  onPrefillChanged(_propName?: string): void {
    if (!this.prefillJson) {
      return;
    }
    this.cancelPendingHistorySave();
    try {
      const data = JSON.parse(this.prefillJson) as PrefillData;
      if (!data || !data.category) {
        return;
      }
      if (!this.unitCategories.includes(data.category)) {
        return;
      }
      const units = ConversionService.getUnitsForCategory(data.category) as string[];
      if (!units.includes(data.fromUnit) || !units.includes(data.toUnit)) {
        return;
      }
      this.unitCategory = data.category;
      this.fromUnit = data.fromUnit as AnyUnit;
      this.toUnit = data.toUnit as AnyUnit;
      this.fromNumber = data.fromValue;
      this.recompute();
      this.refreshFavoriteFlag();
    } catch (_e) {
      // ignore malformed payload
    }
    PreferencesService.clearPrefillRecord();
  }

  private recompute(): void {
    const value = Number(this.fromNumber);
    if (!isFinite(value)) {
      this.toNumber = '—';
      return;
    }
    const result = ConversionService.convert(value, this.fromUnit, this.toUnit);
    this.toNumber = ConversionService.formatResult(result);
  }

  private commitHistory(): void {
    this.cancelPendingHistorySave();
    if (!this.canCommitHistory()) {
      return;
    }
    const record = new ConversionRecord(
      this.unitCategory,
      this.fromUnit,
      this.toUnit,
      this.fromNumber,
      this.toNumber
    );
    PreferencesService.addHistory(record);
  }

  private persistLastUsed(): void {
    PreferencesService.saveLastUsed(this.unitCategory, this.fromUnit, this.toUnit);
    PreferencesService.saveLastUsedForCategory(this.unitCategory, this.fromUnit, this.toUnit);
  }

  private canCommitHistory(): boolean {
    return this.fromNumber !== '0' && this.fromNumber !== '0.' && this.toNumber !== '—';
  }

  private cancelPendingHistorySave(): void {
    if (this.historySaveTimer < 0) {
      return;
    }
    clearTimeout(this.historySaveTimer);
    this.historySaveTimer = -1;
  }

  private scheduleHistorySave(): void {
    this.cancelPendingHistorySave();
    if (!this.canCommitHistory()) {
      return;
    }
    this.historySaveTimer = setTimeout(() => {
      this.historySaveTimer = -1;
      this.commitHistory();
    }, CalculatorComponent.HISTORY_SAVE_DELAY_MS);
  }

  updateFromNumber(newNum: string): void {
    if (newNum === 'C') {
      this.commitHistory();
      this.fromNumber = '0';
      this.toNumber = '0';
      this.refreshFavoriteFlag();
      return;
    }
    if (newNum === '⌫' || newNum === '←' || newNum === 'DEL') {
      if (this.fromNumber.length <= 1) {
        this.fromNumber = '0';
      } else {
        this.fromNumber = this.fromNumber.slice(0, -1);
      }
      this.recompute();
      this.scheduleHistorySave();
      return;
    }
    if (newNum === '.') {
      if (this.fromNumber.includes('.')) {
        return;
      }
      this.fromNumber = this.fromNumber === '' ? '0.' : `${this.fromNumber}.`;
      this.recompute();
      this.scheduleHistorySave();
      return;
    }
    if (this.fromNumber === '0') {
      this.fromNumber = newNum;
    } else if (this.fromNumber.length >= 12) {
      return;
    } else {
      this.fromNumber = `${this.fromNumber}${newNum}`;
    }
    this.recompute();
    this.scheduleHistorySave();
  }

  private onCategoryChange(newCategory: string): void {
    if (newCategory === this.unitCategory) {
      return;
    }
    this.unitCategory = newCategory;
    // Restore per-category last-used or fall back to defaults
    const saved: CatLastUsedResult | undefined = PreferencesService.getLastUsedForCategory(newCategory);
    const units = ConversionService.getUnitsForCategory(newCategory) as string[];
    if (saved && units.includes(saved.from) && units.includes(saved.to)) {
      this.fromUnit = saved.from as AnyUnit;
      this.toUnit = saved.to as AnyUnit;
    } else {
      const defaults = ConversionService.getDefaultsForCategory(newCategory);
      this.fromUnit = defaults[0];
      this.toUnit = defaults[1];
    }
    this.persistLastUsed();
    this.refreshFavoriteFlag();
    this.recompute();
    this.scheduleHistorySave();
  }

  private onFromUnitChange(newUnit: AnyUnit): void {
    if (newUnit === this.toUnit) {
      this.toUnit = this.fromUnit;
    }
    this.fromUnit = newUnit;
    this.persistLastUsed();
    this.refreshFavoriteFlag();
    this.recompute();
    this.scheduleHistorySave();
  }

  private onToUnitChange(newUnit: AnyUnit): void {
    if (newUnit === this.fromUnit) {
      this.fromUnit = this.toUnit;
    }
    this.toUnit = newUnit;
    this.persistLastUsed();
    this.refreshFavoriteFlag();
    this.recompute();
    this.scheduleHistorySave();
  }

  private swapUnits(): void {
    const prevFrom = this.fromUnit;
    this.fromUnit = this.toUnit;
    this.toUnit = prevFrom;
    this.persistLastUsed();
    this.refreshFavoriteFlag();
    this.recompute();
    this.scheduleHistorySave();
  }

  private copyResult(): void {
    FeedbackService.copyToClipboard(this.toNumber);
  }

  private openHistory(): void {
    this.commitHistory();
    this.pathStack.pushPathByName('HistoryPage', null);
  }

  private openFavorites(): void {
    this.commitHistory();
    this.pathStack.pushPathByName('FavoritesPage', null);
  }

  private selectedUnitIndex(unit: AnyUnit): number {
    const units = ConversionService.getUnitsForCategory(this.unitCategory);
    const idx = units.indexOf(unit);
    return idx < 0 ? 0 : idx;
  }

  private openPicker(title: string, range: string[], selected: number,
    onConfirm: (index: number, value: string) => void): void {
    this.pickerTitle = title;
    this.pickerRange = range;
    this.pickerSelected = selected;
    this.pickerOnConfirm = onConfirm;
    this.pickerController.open();
  }

  private openCategoryPicker(): void {
    this.openPicker(
      'Category',
      this.unitCategories,
      this.unitCategories.indexOf(this.unitCategory),
      (index: number, value: string) => this.onCategoryChange(value)
    );
  }

  private openFromUnitPicker(): void {
    const units = ConversionService.getUnitsForCategory(this.unitCategory) as string[];
    this.openPicker(
      'From',
      units,
      this.selectedUnitIndex(this.fromUnit),
      (index: number, value: string) => this.onFromUnitChange(value as AnyUnit)
    );
  }

  private openToUnitPicker(): void {
    const units = ConversionService.getUnitsForCategory(this.unitCategory) as string[];
    this.openPicker(
      'To',
      units,
      this.selectedUnitIndex(this.toUnit),
      (index: number, value: string) => this.onToUnitChange(value as AnyUnit)
    );
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Column({ space: '2vp' }) {
        Blank()
          .height('6vp')

        CalcResultComponent({
          fromNumber: this.fromNumber,
          toNumber: this.toNumber,
          fromUnit: this.fromUnit,
          toUnit: this.toUnit,
          unitCategory: this.unitCategory,
          isFavorite: this.favorite,
          onUnitCatClicked: () => this.openCategoryPicker(),
          onFromUnitClicked: () => this.openFromUnitPicker(),
          onToUnitClicked: () => this.openToUnitPicker(),
          onSwapUnits: () => this.swapUnits(),
          onResultTap: () => this.copyResult(),
          onHistoryTap: () => this.openHistory(),
          onFavoriteTap: () => this.openFavorites()
        })

        Column({ space: '3vp' }) {
          ForEach(KEYPAD_ROWS, (row: KeyDef[]) => {
            Row({ space: '3vp' }) {
              ForEach(row, (key: KeyDef) => {
                CalcButton({
                  text: key.label,
                  color: key.color,
                  onBtnClick: () => this.updateFromNumber(key.label)
                })
                  .layoutWeight(1)
              }, (key: KeyDef) => key.label)
            }
            .justifyContent(FlexAlign.Center)
            .width(row.length === 1 ? '48%' : '100%')
          }, (row: KeyDef[]) => row.map((k: KeyDef) => k.label).join('-'))
        }
        .width('76%')
        .margin({ top: '20vp' })

        Blank()
          .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
      .padding({ left: '6vp', right: '6vp', top: '10vp', bottom: '8vp' })
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Center)

      Row() {
        Button() {
          Text('≡')
            .fontSize('12fp')
            .fontColor('#ff16303a')
            .textAlign(TextAlign.Center)
            .fontWeight(FontWeight.Medium)
        }
        .width('22vp')
        .height('22vp')
        .borderRadius('11vp')
        .backgroundColor('#ff9fc9da')
        .border({ width: '1vp', color: '#35ffffff' })
        .onClick(() => this.openHistory())

        Blank()
          .layoutWeight(1)

        Button() {
          Text(this.favorite ? '★' : '☆')
            .fontSize('11fp')
            .fontColor('#ff4a3310')
            .textAlign(TextAlign.Center)
            .fontWeight(FontWeight.Medium)
        }
        .width('22vp')
        .height('22vp')
        .borderRadius('11vp')
        .backgroundColor(this.favorite ? '#fff0d98c' : '#ffe9d8a7')
        .border({ width: '1vp', color: '#35ffffff' })
        .onClick(() => this.openFavorites())
      }
      .width('100%')
      .padding({ left: '4vp', right: '4vp' })
      .position({ x: 0, y: '39%' })
    }
    .width('100%')
    .height('100%')
  }
}
