@CustomDialog
export struct UnitPickerDialog {
  controller: CustomDialogController;
  @Prop title: string;
  @Prop @Watch('resetSelection') range: string[];
  @Prop @Watch('resetSelection') selectedIndex: number;
  onConfirm: (index: number, value: string) => void = () => {
  };
  @State private currentIdx: number = 0;
  @State private currentValue: string = '';

  aboutToAppear(): void {
    this.resetSelection();
  }

  resetSelection(_prop?: string): void {
    this.currentIdx = this.selectedIndex;
    this.currentValue = this.range[this.selectedIndex] ?? this.range[0] ?? '';
  }

  build() {
    Column({ space: '8vp' }) {
      // Title
      Text(this.title)
        .fontSize('13fp')
        .fontWeight(FontWeight.Bold)
        .fontColor('#ffa4cba1')
        .textAlign(TextAlign.Center)
        .width('100%')

      // Picker
      TextPicker({
        range: this.range,
        selected: this.currentIdx
      })
        .onChange((value: string | string[], index: number | number[]) => {
          this.currentIdx = Array.isArray(index) ? index[0] : index;
          this.currentValue = Array.isArray(value) ? value[0] : value;
        })
        .width('100%')
        .height('100vp')
        .disappearTextStyle({ color: '#88aaaaaa', font: { size: '11fp' } })
        .textStyle({ color: '#ffcccccc', font: { size: '12fp' } })
        .selectedTextStyle({ color: '#ffa4cba1', font: { size: '15fp', weight: FontWeight.Bold } })

      // Buttons
      Row({ space: '8vp' }) {
        Button() {
          Text('Cancel')
            .fontSize('12fp')
            .fontColor('#ffaaaaaa')
        }
        .layoutWeight(1)
        .height('28vp')
        .backgroundColor('#33ffffff')
        .borderRadius('14vp')
        .onClick(() => this.controller.close())

        Button() {
          Text('OK')
            .fontSize('12fp')
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Bold)
        }
        .layoutWeight(1)
        .height('28vp')
        .backgroundColor('#ffa4cba1')
        .borderRadius('14vp')
        .onClick(() => {
          this.onConfirm(this.currentIdx, this.currentValue);
          this.controller.close();
        })
      }
      .width('100%')
    }
    .padding({ top: '12vp', bottom: '12vp', left: '12vp', right: '12vp' })
    .width('82%')
    .backgroundColor('#e6111111')
    .borderRadius('20vp')
  }
}
