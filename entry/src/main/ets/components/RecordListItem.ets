import { ConversionRecord } from '../models/ConversionRecord';

@Component
export struct RecordListItem {
  @Prop record: ConversionRecord;
  @Prop trailingIcon: string;
  @Prop trailingFontSize: Length = '14fp';
  @Prop trailingBackground: ResourceColor = '#ffe5d4a1';
  @Prop trailingForeground: ResourceColor = Color.Black;
  @Prop highlighted: boolean = false;
  onItemTap: () => void = () => {
  };
  onTrailingTap: () => void = () => {
  };

  build() {
    Row({ space: '4vp' }) {
      Column({ space: '2vp' }) {
        Row({ space: '4vp' }) {
          Text(this.record.category)
            .fontSize('10fp')
            .fontColor(this.highlighted ? '#ff775300' : '#ff6e6e6e')
          Text(`${this.record.fromUnit} → ${this.record.toUnit}`)
            .fontSize('10fp')
            .fontColor(this.highlighted ? '#ff775300' : '#ff6e6e6e')
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)

        Row({ space: '4vp' }) {
          Text(this.record.fromValue)
            .fontSize('14fp')
            .fontColor(Color.Black)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
            .layoutWeight(1)
          Text('=')
            .fontSize('12fp')
            .fontColor(this.highlighted ? '#ff775300' : '#ff6e6e6e')
          Text(this.record.toValue)
            .fontSize('14fp')
            .fontColor(Color.Black)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
            .layoutWeight(1)
        }
        .width('100%')
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .onClick(this.onItemTap)

      Button() {
        Text(this.trailingIcon)
          .fontSize(this.trailingFontSize)
          .fontColor(this.trailingForeground)
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Center)
          .maxLines(1)
      }
      .width('30vp')
      .height('26vp')
      .borderRadius('13vp')
      .backgroundColor(this.trailingBackground)
      .onClick(this.onTrailingTap)
      .clickEffect({ level: ClickEffectLevel.HEAVY, scale: 0.9 })
    }
    .width('100%')
    .padding({ left: '12vp', right: '12vp', top: '6vp', bottom: '6vp' })
    .backgroundColor(this.highlighted ? '#fff9efcb' : '#fff6f6f6')
    .borderRadius('12vp')
  }
}
