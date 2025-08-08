import { CalculatorComponent } from '../components/CalculatorComponent';

@Entry
@Component
struct Index {
  @Provide('NavPathStack')
  pathStack: NavPathStack = new NavPathStack();

  build() {
    RelativeContainer() {
      Navigation(this.pathStack) {
        CalculatorComponent()
      }
      .hideTitleBar(true)
      .hideBackButton(true)
      .height('100%')
      .width('100%')
    }
    .height('100%')
    .width('100%')
  }
}