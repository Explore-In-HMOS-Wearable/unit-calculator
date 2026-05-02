import { ConversionRecord } from '../models/ConversionRecord';
import { PreferencesService, PrefKeys } from '../services/PreferencesService';
import { RecordListItem } from '../components/RecordListItem';

@Component
export struct HistoryPage {
  @Consume('NavPathStack') pathStack: NavPathStack;
  @StorageLink(PrefKeys.HISTORY_JSON) @Watch('reload') private historyJson: string = '[]';
  @StorageLink(PrefKeys.FAVORITES_JSON) @Watch('onFavoritesChanged') private favoritesJson: string = '[]';
  @State private records: ConversionRecord[] = [];
  @State private favoriteKeys: string[] = [];

  aboutToAppear(): void {
    this.reload();
  }

  private reload(_propName?: string): void {
    this.records = PreferencesService.loadHistory();
    this.reloadFavoriteKeys();
  }

  private onFavoritesChanged(_propName?: string): void {
    this.reloadFavoriteKeys();
  }

  private reloadFavoriteKeys(): void {
    this.favoriteKeys = PreferencesService.loadFavorites().map((record: ConversionRecord) => record.key());
  }

  private isFavoriteRecord(record: ConversionRecord): boolean {
    return this.favoriteKeys.includes(record.key());
  }

  private onItemTap(record: ConversionRecord): void {
    PreferencesService.setPrefillRecord(record);
    this.pathStack.pop();
  }

  private onFavoriteToggle(record: ConversionRecord): void {
    if (this.isFavoriteRecord(record)) {
      PreferencesService.removeFavorite(record.key());
    } else {
      PreferencesService.addFavorite(record);
    }
    this.reloadFavoriteKeys();
  }

  private clearAll(): void {
    PreferencesService.clearHistory();
    this.reload();
  }

  private openFavorites(): void {
    this.pathStack.pop();
    this.pathStack.pushPathByName('FavoritesPage', null);
  }

  private goBack(): void {
    this.pathStack.pop();
  }

  build() {
    NavDestination() {
      Column({ space: '8vp' }) {
        Blank()
          .height('12vp')

        Column({ space: '8vp' }) {
          Text('History')
            .fontSize('16fp')
            .fontWeight(FontWeight.Bold)
            .fontColor('#fff4f4f4')
            .textAlign(TextAlign.Center)
            .maxLines(1)
            .width('100%')

          Row({ space: '10vp' }) {
            Button() {
              Text('‹')
                .fontSize('16fp')
                .fontWeight(FontWeight.Bold)
                .fontColor('#ffffffff')
            }
            .width('30vp')
            .height('30vp')
            .borderRadius('15vp')
            .backgroundColor('#ff5f97b1')
            .onClick(() => this.goBack())

            Button() {
              Text('CLR')
                .fontSize('9fp')
                .fontWeight(FontWeight.Medium)
                .fontColor('#ffffffff')
            }
            .width('30vp')
            .height('30vp')
            .borderRadius('15vp')
            .backgroundColor('#ffa07f47')
            .onClick(() => this.clearAll())
            .enabled(this.records.length > 0)

            Button() {
              Text('★')
                .fontSize('12fp')
                .fontWeight(FontWeight.Medium)
                .fontColor('#ff4a3310')
            }
            .width('30vp')
            .height('30vp')
            .borderRadius('15vp')
            .backgroundColor('#ffe5bf52')
            .onClick(() => this.openFavorites())
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
        }
        .width('70%')
        .alignItems(HorizontalAlign.Center)

        if (this.records.length === 0) {
          Column() {
            Text('No history yet')
              .fontSize('13fp')
              .fontColor('#ffd8d8d8')
              .textAlign(TextAlign.Center)
          }
          .layoutWeight(1)
          .width('72%')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        } else {
          List({ space: '6vp' }) {
            ForEach(this.records, (record: ConversionRecord) => {
              ListItem() {
                RecordListItem({
                  record: record,
                  trailingIcon: this.isFavoriteRecord(record) ? '★' : '☆',
                  trailingFontSize: '14fp',
                  trailingBackground: this.isFavoriteRecord(record) ? '#ffe5bf52' : '#fffdf8ec',
                  trailingForeground: this.isFavoriteRecord(record) ? '#ff4a3310' : '#ff9b7421',
                  highlighted: this.isFavoriteRecord(record),
                  onItemTap: () => this.onItemTap(record),
                  onTrailingTap: () => this.onFavoriteToggle(record)
                })
              }
            }, (record: ConversionRecord) => record.id)
          }
          .layoutWeight(1)
          .width('74%')
          .padding({ bottom: '4vp' })
          .scrollBar(BarState.Off)
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: '8vp', right: '8vp', top: '8vp', bottom: '12vp' })
      .alignItems(HorizontalAlign.Center)
    }
    .hideTitleBar(true)
  }
}
