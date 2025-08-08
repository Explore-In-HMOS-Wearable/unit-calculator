import { AnyUnit, converters } from '../utils/UnitUtils';
import { UnitButton } from './UnitButton';

@Component
export struct CalcResultComponent {
  @Prop fromNumber: string;
  @Prop toNumber: string;
  @Link fromUnit: AnyUnit;
  @Link toUnit: AnyUnit;
  @Link unitCategory: string;
  onUnitCatClicked: () => void = () => {
  };
  onFromUnitClicked: () => void = () => {
  };
  onToUnitClicked: () => void = () => {
  };

  onUnitChanged() {
    const converter = converters.find(entry =>
    entry.units.includes(this.fromUnit) && entry.units.includes(this.toUnit)
    );
    if (converter) {
      this.unitCategory = converter?.category ?? converters[0].category;
    }
  }

  build() {
    Column({ space: '4vp' }) {
      Button() {
        Text(this.unitCategory)
          .fontColor(Color.Black)
          .textAlign(TextAlign.Center)
          .maxFontSize('20fp')
          .minFontSize('8fp')
          .layoutWeight(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .width('70vp')
      }
      .onClick(this.onUnitCatClicked)
      .focusable(true)
      .focusOnTouch(true)
      .width('100%')
      .height('26vp')
      .backgroundColor('#ffa4cba1')


      Row({ space: '2vp' }) {
        UnitButton({
          unit: this.fromUnit,
          onUnitClicked: this.onFromUnitClicked
        })
        Text(this.fromNumber.toString())
          .textAlign(TextAlign.Start)
          .maxFontSize('20fp')
          .minFontSize('10fp')
          .layoutWeight(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
      }
      .padding({ left: '40vp', right: '40vp' })
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Start)

      Divider()
        .color('#ff8ab8ca')

      Row({ space: '2vp' }) {
        UnitButton({
          unit: this.toUnit,
          onUnitClicked: this.onToUnitClicked
        })
        Text(this.toNumber.toString())
          .textAlign(TextAlign.Start)
          .maxFontSize('20fp')
          .minFontSize('10fp')
          .layoutWeight(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
      }
      .padding({ left: '40vp', right: '40vp' })
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Start)
    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Start)
    .width('100%')
  }
}