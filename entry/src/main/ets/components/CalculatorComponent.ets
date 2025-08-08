import { converters, AnyUnit } from '../utils/UnitUtils';
import { LengthUnit, LENGTH_UNITS } from '../utils/UnitEnums';
import { CalcResultComponent } from './CalcResultComponent';
import { CalcButton } from './CalcButton';

@Component
export struct CalculatorComponent {
  @State private fromNumber: string = '0';
  @State private toNumber: string = '0';
  @State private fromUnit: AnyUnit = LengthUnit.CENTIMETER;
  @State private toUnit: AnyUnit = LengthUnit.METER;
  @State unitCategory: string = converters[0].category;
  private unitCategories: string[] = converters.map((e) => e.category)
  private context: UIContext = this.getUIContext();

  convertUnit(value: number): number {
    const converter = converters.find(entry =>
    entry.units.includes(this.fromUnit) && entry.units.includes(this.toUnit)
    );

    if (!converter) {
      throw new Error('Incompatible or unknown unit types.');
    }
    return converter.fn(value, this.fromUnit, this.toUnit);
  }

  currentConverter() {
    return converters.find(entry =>
    entry.units.includes(this.fromUnit) && entry.units.includes(this.toUnit)
    );
  }

  selectedUnitIndex(unit: AnyUnit): number {
    const converter = this.currentConverter();

    const selectedIndex = (converter?.units ?? LENGTH_UNITS).indexOf(unit);
    if (selectedIndex < 0) {
      return 0;
    }
    return selectedIndex;
  }

  updateFromNumber(newNum: string) {
    console.log(this.fromNumber);
    if (newNum === '.' && this.fromNumber === '0') {
      this.fromNumber = '0.';
    } else if (newNum === 'C') {
      this.fromNumber = '0'
      this.toNumber = '0'
    } else if (this.fromNumber.length === 1 && this.fromNumber.startsWith('0')) {
      this.fromNumber = newNum;
      this.toNumber = this.convertUnit(Number(newNum)).toString();
    } else if (newNum === '.' && this.fromNumber.includes('.')) {
      return;
    } else {
      this.fromNumber += newNum;
      this.toNumber = this.convertUnit(Number(this.fromNumber)).toString();
      console.log(this.toNumber);
    }
  }

  build() {
    Column() {
      CalcResultComponent({
        fromNumber: this.fromNumber,
        toNumber: this.toNumber,
        fromUnit: this.fromUnit,
        toUnit: this.toUnit,
        unitCategory: this.unitCategory,
        onUnitCatClicked: () => {
          this.context.showTextPickerDialog({
            range: this.unitCategories,
            selected: this.unitCategories.indexOf(this.unitCategory),
            onAccept: (value: TextPickerResult) => {
              const newCat = this.unitCategories.find((_, i) => i === value.index);
              if (!newCat) {
                return;
              }
              if (newCat !== this.unitCategory) {
                this.unitCategory = newCat;
                this.fromUnit = converters.find((e) => e.category === newCat)?.units[0];
                this.toUnit = converters.find((e) => e.category === newCat)?.units[1];
                this.toNumber = this.convertUnit(Number(this.fromNumber)).toString();
              }
            },
          })
        },
        onFromUnitClicked: () => {
          this.context.showTextPickerDialog({
            range: this.currentConverter()?.units ?? LENGTH_UNITS,
            selected: this.selectedUnitIndex(this.fromUnit),
            onAccept: (value: TextPickerResult) => {
              const newUnit = this.currentConverter()?.units.find((unit) => unit === value.value);
              if (!newUnit) {
                return;
              }
              if (newUnit === this.toUnit) {
                this.toUnit = this.fromUnit;
              }
              this.fromUnit = newUnit;
              this.toNumber = this.convertUnit(Number(this.fromNumber)).toString();
            },
          })
        },
        onToUnitClicked: () => {
          this.context.showTextPickerDialog({
            range: this.currentConverter()?.units ?? LENGTH_UNITS,
            selected: this.selectedUnitIndex(this.toUnit),
            onAccept: (value: TextPickerResult) => {
              const newUnit = this.currentConverter()?.units.find((unit) => unit === value.value);
              if (!newUnit) {
                return;
              }
              if (newUnit === this.fromUnit) {
                this.fromUnit = this.toUnit;
              }
              this.toUnit = newUnit;
              this.toNumber = this.convertUnit(Number(this.fromNumber)).toString();
            },
          })
        }
      })

      Divider()
        .margin({ top: '2vp' })
        .vertical(false)
        .color('#ffececec')

      Column({ space: '4vp' }) {
        Row({ space: '4vp' }) {
          CalcButton({
            text: '7',
            onBtnClick: () => {
              this.updateFromNumber('7');
            }
          }).layoutWeight(1)

          CalcButton({
            text: '8',
            onBtnClick: () => {
              this.updateFromNumber('8');
            }
          }).layoutWeight(1)

          CalcButton({
            text: '9',
            onBtnClick: () => {
              this.updateFromNumber('9');
            }
          }).layoutWeight(1)

          CalcButton({
            text: 'C',
            color: '#ffd6ca82',
            onBtnClick: () => {
              this.updateFromNumber('C');
            }
          }).layoutWeight(1)
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')

        Row({ space: '4vp' }) {
          CalcButton({
            text: '4',
            onBtnClick: () => {
              this.updateFromNumber('4');
            }
          }).layoutWeight(1)

          CalcButton({
            text: '5',
            onBtnClick: () => {
              this.updateFromNumber('5');
            }
          }).layoutWeight(1)

          CalcButton({
            text: '6',
            onBtnClick: () => {
              this.updateFromNumber('6');
            }
          }).layoutWeight(1)

          CalcButton({
            text: '.',
            onBtnClick: () => {
              this.updateFromNumber('.');
            }
          }).layoutWeight(1)
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')

        Row({ space: '4vp' }) {
          CalcButton({
            text: '1',
            onBtnClick: () => {
              this.updateFromNumber('1');
            }
          }).layoutWeight(1)

          CalcButton({
            text: '2',
            onBtnClick: () => {
              this.updateFromNumber('2');
            }
          }).layoutWeight(1)

          CalcButton({
            text: '3',
            onBtnClick: () => {
              this.updateFromNumber('3');
            }
          }).layoutWeight(1)

          CalcButton({
            text: '0',
            onBtnClick: () => {
              this.updateFromNumber('0');
            }
          }).layoutWeight(1)
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
      }
      .margin({ top: '2vp' })
      .padding({ left: '32vp', right: '32vp' })
    }
    .width('100%')
    .padding({ bottom: '16vp' })
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}