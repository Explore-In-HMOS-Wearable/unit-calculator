import { CalculatorComponent } from '../components/CalculatorComponent';
import { HistoryPage } from './HistoryPage';
import { FavoritesPage } from './FavoritesPage';
import { MultiResultPage } from './MultiResultPage';

@Entry
@Component
struct Index {
  @Provide('NavPathStack')
  pathStack: NavPathStack = new NavPathStack();

  @Builder
  pageMap(name: string) {
    if (name === 'HistoryPage') {
      HistoryPage()
    } else if (name === 'FavoritesPage') {
      FavoritesPage()
    } else if (name === 'MultiResultPage') {
      MultiResultPage()
    }
  }

  build() {
    Navigation(this.pathStack) {
      CalculatorComponent()
    }
    .hideTitleBar(true)
    .hideBackButton(true)
    .navDestination(this.pageMap)
    .height('100%')
    .width('100%')
  }
}
