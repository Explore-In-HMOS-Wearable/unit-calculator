import { AnyUnit } from '../utils/UnitUtils';
import { ConversionService } from '../services/ConversionService';
import { FeedbackService } from '../services/FeedbackService';

interface MultiResultParam {
  category: string;
  fromUnit: string;
  fromValue: string;
}

interface ResultRow {
  unit: string;
  result: string;
  isSource: boolean;
}

@Component
export struct MultiResultPage {
  @Consume('NavPathStack') pathStack: NavPathStack;
  @State private category: string = '';
  @State private fromUnit: string = '';
  @State private fromValue: string = '0';
  @State private rows: ResultRow[] = [];

  private loadResults(category: string, fromUnit: string, fromValue: string): void {
    this.category = category;
    this.fromUnit = fromUnit;
    this.fromValue = fromValue;
    const value = Number(fromValue);
    const units = ConversionService.getUnitsForCategory(category);
    this.rows = units.map((unit: AnyUnit): ResultRow => {
      const unitStr = unit as string;
      const result = isFinite(value)
        ? ConversionService.formatResult(ConversionService.convert(value, fromUnit as AnyUnit, unit))
        : '—';
      const row: ResultRow = { unit: unitStr, result: result, isSource: unitStr === fromUnit };
      return row;
    });
  }

  private goBack(): void {
    this.pathStack.pop();
  }

  build() {
    NavDestination() {
      Column() {
        // Header
        Row({ space: '4vp' }) {
          Button() {
            Text('‹')
              .fontSize('18fp')
              .fontColor(Color.Black)
          }
          .width('26vp')
          .height('26vp')
          .borderRadius('13vp')
          .backgroundColor('#ff8ab8ca')
          .onClick(() => this.goBack())

          Column({ space: '1vp' }) {
            Text(this.category)
              .fontSize('14fp')
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.Black)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })

            Text(`${this.fromValue} ${this.fromUnit}`)
              .fontSize('11fp')
              .fontColor('#ff6e6e6e')
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Center)

          // Spacer to balance header
          Column()
            .width('26vp')
            .height('26vp')
        }
        .width('100%')
        .padding({ left: '8vp', right: '8vp', top: '6vp', bottom: '6vp' })

        if (this.rows.length === 0) {
          Column() {
            Text('No results')
              .fontSize('12fp')
              .fontColor('#ff6e6e6e')
          }
          .layoutWeight(1)
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        } else {
          List({ space: '4vp' }) {
            ForEach(this.rows, (row: ResultRow) => {
              ListItem() {
                Row() {
                  Text(row.unit)
                    .fontSize('13fp')
                    .fontColor(row.isSource ? '#ff4caf50' : Color.Black)
                    .fontWeight(row.isSource ? FontWeight.Bold : FontWeight.Normal)
                    .layoutWeight(1)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })

                  Text(row.result)
                    .fontSize('13fp')
                    .fontColor(row.isSource ? '#ff4caf50' : Color.Black)
                    .fontWeight(row.isSource ? FontWeight.Bold : FontWeight.Normal)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .textAlign(TextAlign.End)
                    .layoutWeight(1)
                }
                .width('100%')
                .padding({ left: '12vp', right: '12vp', top: '8vp', bottom: '8vp' })
                .backgroundColor(row.isSource ? '#11a4cba1' : '#00000000')
                .borderRadius('10vp')
                .onClick(() => {
                  FeedbackService.copyToClipboard(row.result);
                })
              }
            }, (row: ResultRow) => row.unit)
          }
          .layoutWeight(1)
          .width('100%')
          .padding({ left: '8vp', right: '8vp', bottom: '8vp' })
          .scrollBar(BarState.Off)
        }
      }
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
    .onReady((ctx: NavDestinationContext) => {
      const p = ctx.pathInfo.param as MultiResultParam;
      if (p && p.category) {
        this.loadResults(p.category, p.fromUnit, p.fromValue);
      }
    })
  }
}
