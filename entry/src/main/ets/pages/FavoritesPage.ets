import { ConversionRecord } from '../models/ConversionRecord';
import { PreferencesService, PrefKeys } from '../services/PreferencesService';
import { RecordListItem } from '../components/RecordListItem';

@Component
export struct FavoritesPage {
  @Consume('NavPathStack') pathStack: NavPathStack;
  @StorageLink(PrefKeys.FAVORITES_JSON) private favoritesJson: string = '[]';
  @State private records: ConversionRecord[] = [];

  aboutToAppear(): void {
    this.reload();
  }

  private reload(): void {
    this.records = PreferencesService.loadFavorites();
  }

  private onItemTap(record: ConversionRecord): void {
    PreferencesService.setPrefillRecord(record);
    this.pathStack.pop();
  }

  private onRemove(record: ConversionRecord): void {
    PreferencesService.removeFavorite(record.key());
    this.reload();
  }

  private openHistory(): void {
    this.pathStack.pop();
    this.pathStack.pushPathByName('HistoryPage', null);
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
          Text('Favorites')
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
              Text('HIS')
                .fontSize('8fp')
                .fontWeight(FontWeight.Medium)
                .fontColor('#ff16303a')
            }
            .width('30vp')
            .height('30vp')
            .borderRadius('15vp')
            .backgroundColor('#ff9fc9da')
            .onClick(() => this.openHistory())
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
        }
        .width('70%')
        .alignItems(HorizontalAlign.Center)

        if (this.records.length === 0) {
          Column() {
            Text('No favorites yet')
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
                  trailingIcon: 'DEL',
                  trailingFontSize: '8fp',
                  trailingBackground: '#ffcf8f73',
                  trailingForeground: '#ffffffff',
                  highlighted: true,
                  onItemTap: () => this.onItemTap(record),
                  onTrailingTap: () => this.onRemove(record)
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
