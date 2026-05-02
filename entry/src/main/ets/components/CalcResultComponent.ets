import { AnyUnit } from '../utils/UnitUtils';
import { UnitButton } from './UnitButton';

@Component
export struct CalcResultComponent {
  @Prop fromNumber: string;
  @Prop toNumber: string;
  @Prop isFavorite: boolean;
  @Link fromUnit: AnyUnit;
  @Link toUnit: AnyUnit;
  @Link unitCategory: string;
  onUnitCatClicked: () => void = () => {
  };
  onFromUnitClicked: () => void = () => {
  };
  onToUnitClicked: () => void = () => {
  };
  onSwapUnits: () => void = () => {
  };
  onResultTap: () => void = () => {
  };
  onHistoryTap: () => void = () => {
  };
  onFavoriteTap: () => void = () => {
  };

  build() {
    Column({ space: '3vp' }) {
      Button() {
        Text(this.unitCategory)
          .fontColor(Color.Black)
          .textAlign(TextAlign.Center)
          .maxFontSize('11fp')
          .minFontSize('8fp')
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
      }
      .width('56%')
      .height('20vp')
      .borderRadius('10vp')
      .backgroundColor('#ffa4cba1')
      .onClick(this.onUnitCatClicked)

      Row({ space: '3vp' }) {
        Column({ space: '2vp' }) {
          UnitButton({
            unit: this.fromUnit,
            onUnitClicked: this.onFromUnitClicked
          })
          Text(this.fromNumber)
            .textAlign(TextAlign.Center)
            .maxFontSize('15fp')
            .minFontSize('8fp')
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
            .fontWeight(FontWeight.Medium)
            .width('100%')
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)
        .padding({ left: '3vp', right: '3vp', top: '4vp', bottom: '3vp' })
        .borderRadius('12vp')
        .backgroundColor('#12ffffff')

        Button() {
          Text('⇄')
            .fontSize('11fp')
            .fontColor(Color.Black)
            .textAlign(TextAlign.Center)
        }
        .width('20vp')
        .height('20vp')
        .borderRadius('10vp')
        .backgroundColor('#ff8ab8ca')
        .onClick(this.onSwapUnits)

        Column({ space: '3vp' }) {
          UnitButton({
            unit: this.toUnit,
            onUnitClicked: this.onToUnitClicked
          })
          Text(this.toNumber)
            .textAlign(TextAlign.Center)
            .maxFontSize('15fp')
            .minFontSize('8fp')
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
            .onClick(this.onResultTap)
            .fontWeight(FontWeight.Medium)
            .width('100%')
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)
        .padding({ left: '3vp', right: '3vp', top: '4vp', bottom: '3vp' })
        .borderRadius('12vp')
        .backgroundColor('#12ffffff')
      }
      .width('72%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Start)
    .width('100%')
    .padding({ top: '4vp', bottom: '1vp' })
  }
}
