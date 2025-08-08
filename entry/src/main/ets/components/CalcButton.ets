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
        .fontSize('18fp')
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
    .height('36vp')
    .borderRadius('18vp')
    .backgroundColor(this.color ?? '#ffa4cba1')
  }
}