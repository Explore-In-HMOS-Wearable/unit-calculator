import { AnyUnit } from '../utils/UnitUtils';

@Component
export struct UnitButton {
  @Prop unit: AnyUnit;
  onUnitClicked: () => void = () => {
  };

  build() {
    Button() {
      Text(this.unit)
        .fontSize('18fp')
        .fontColor(Color.Black)
        .textAlign(TextAlign.Center)
    }
    .onClick(this.onUnitClicked)
    .clickEffect({ level: ClickEffectLevel.HEAVY, scale: 0.9 })
    .focusable(true)
    .focusOnTouch(true)
    .width('60vp')
    .height('26vp')
    .borderRadius('16vp')
    .backgroundColor('#ff8ab8ca')
  }
}