@Component
export struct CalcButton {
  text?: string;
  color?: ResourceColor;
  onBtnClick?: () => void;

  build() {
    Button() {
      Text(this.text)
        .fontColor(Color.Black)
        .textAlign(TextAlign.Center)
        .maxFontSize('13fp')
        .minFontSize('8fp')
        .maxLines(1)
    }
    .onClick(() => {
      if (this.onBtnClick) {
        this.onBtnClick();
      }
    })
    .clickEffect({ level: ClickEffectLevel.HEAVY, scale: 0.9 })
    .focusable(true)
    .focusOnTouch(true)
    .width('100%')
    .height('26vp')
    .borderRadius('13vp')
    .backgroundColor(this.color ?? '#ffa4cba1')
  }
}
