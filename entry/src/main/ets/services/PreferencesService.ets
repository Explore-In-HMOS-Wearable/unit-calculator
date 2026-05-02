import { ConversionRecord } from '../models/ConversionRecord';
import { AnyUnit } from '../utils/UnitUtils';

interface SerializedRecord {
  id: string;
  category: string;
  fromUnit: string;
  toUnit: string;
  fromValue: string;
  toValue: string;
  timestamp: number;
}

interface CatLastUsed {
  cat: string;
  from: string;
  to: string;
}

export interface CatLastUsedResult {
  from: string;
  to: string;
}

export class PrefKeys {
  static readonly LAST_CATEGORY = 'lastCategory';
  static readonly LAST_FROM_UNIT = 'lastFromUnit';
  static readonly LAST_TO_UNIT = 'lastToUnit';
  static readonly HISTORY_JSON = 'historyJson';
  static readonly FAVORITES_JSON = 'favoritesJson';
  static readonly PREFILL_RECORD = 'prefillRecord';
  static readonly CATEGORY_LAST_USED_MAP = 'categoryLastUsedMap';
}

const HISTORY_LIMIT = 20;
const FAVORITES_LIMIT = 20;

export class PreferencesService {
  static initPersistentStorage(): void {
    PersistentStorage.persistProp<string>(PrefKeys.LAST_CATEGORY, '');
    PersistentStorage.persistProp<string>(PrefKeys.LAST_FROM_UNIT, '');
    PersistentStorage.persistProp<string>(PrefKeys.LAST_TO_UNIT, '');
    PersistentStorage.persistProp<string>(PrefKeys.HISTORY_JSON, '[]');
    PersistentStorage.persistProp<string>(PrefKeys.FAVORITES_JSON, '[]');
    PersistentStorage.persistProp<string>(PrefKeys.CATEGORY_LAST_USED_MAP, '[]');
    // PREFILL_RECORD is transient — AppStorage only, not persisted
    AppStorage.setOrCreate<string>(PrefKeys.PREFILL_RECORD, '');
  }

  // ─── Last-used (global) ────────────────────────────────────────────────────

  static saveLastUsed(category: string, fromUnit: AnyUnit, toUnit: AnyUnit): void {
    AppStorage.setOrCreate<string>(PrefKeys.LAST_CATEGORY, category);
    AppStorage.setOrCreate<string>(PrefKeys.LAST_FROM_UNIT, fromUnit);
    AppStorage.setOrCreate<string>(PrefKeys.LAST_TO_UNIT, toUnit);
  }

  static getLastCategory(): string {
    return AppStorage.get<string>(PrefKeys.LAST_CATEGORY) ?? '';
  }

  static getLastFromUnit(): string {
    return AppStorage.get<string>(PrefKeys.LAST_FROM_UNIT) ?? '';
  }

  static getLastToUnit(): string {
    return AppStorage.get<string>(PrefKeys.LAST_TO_UNIT) ?? '';
  }

  // ─── Per-category last-used ────────────────────────────────────────────────

  static saveLastUsedForCategory(category: string, from: AnyUnit, to: AnyUnit): void {
    const raw = AppStorage.get<string>(PrefKeys.CATEGORY_LAST_USED_MAP) ?? '[]';
    let arr: CatLastUsed[] = [];
    try {
      const parsed = JSON.parse(raw) as CatLastUsed[];
      arr = Array.isArray(parsed) ? parsed : [];
    } catch (_e) {
      arr = [];
    }
    const idx = arr.findIndex((e: CatLastUsed) => e.cat === category);
    const entry: CatLastUsed = { cat: category, from: from as string, to: to as string };
    if (idx >= 0) {
      arr[idx] = entry;
    } else {
      arr.push(entry);
    }
    AppStorage.setOrCreate<string>(PrefKeys.CATEGORY_LAST_USED_MAP, JSON.stringify(arr));
  }

  static getLastUsedForCategory(category: string): CatLastUsedResult | undefined {
    const raw = AppStorage.get<string>(PrefKeys.CATEGORY_LAST_USED_MAP) ?? '[]';
    try {
      const arr = JSON.parse(raw) as CatLastUsed[];
      if (!Array.isArray(arr)) {
        return undefined;
      }
      const entry = arr.find((e: CatLastUsed) => e.cat === category);
      if (entry) {
        const result: CatLastUsedResult = { from: entry.from, to: entry.to };
        return result;
      }
    } catch (_e) {
      // ignore
    }
    return undefined;
  }

  // ─── Prefill record (transient) ────────────────────────────────────────────

  static setPrefillRecord(record: ConversionRecord): void {
    AppStorage.setOrCreate<string>(PrefKeys.PREFILL_RECORD, JSON.stringify(record));
  }

  static clearPrefillRecord(): void {
    AppStorage.setOrCreate<string>(PrefKeys.PREFILL_RECORD, '');
  }

  // ─── History ───────────────────────────────────────────────────────────────

  static loadHistory(): ConversionRecord[] {
    return PreferencesService.parseList(AppStorage.get<string>(PrefKeys.HISTORY_JSON));
  }

  static addHistory(record: ConversionRecord): void {
    const list = PreferencesService.loadHistory();
    if (list.length > 0 && PreferencesService.isSameHistoryRecord(list[0], record)) {
      return;
    }
    list.unshift(record);
    const trimmed = list.slice(0, HISTORY_LIMIT);
    PreferencesService.persistList(PrefKeys.HISTORY_JSON, trimmed);
  }

  static clearHistory(): void {
    PreferencesService.persistList(PrefKeys.HISTORY_JSON, []);
  }

  // ─── Favorites ─────────────────────────────────────────────────────────────

  static loadFavorites(): ConversionRecord[] {
    return PreferencesService.parseList(AppStorage.get<string>(PrefKeys.FAVORITES_JSON));
  }

  static addFavorite(record: ConversionRecord): boolean {
    const list = PreferencesService.loadFavorites();
    if (list.some((r: ConversionRecord) => r.key() === record.key())) {
      return false;
    }
    if (list.length >= FAVORITES_LIMIT) {
      return false;
    }
    list.unshift(record);
    PreferencesService.persistList(PrefKeys.FAVORITES_JSON, list);
    return true;
  }

  static removeFavorite(key: string): void {
    const list = PreferencesService.loadFavorites();
    const filtered = list.filter((r: ConversionRecord) => r.key() !== key);
    PreferencesService.persistList(PrefKeys.FAVORITES_JSON, filtered);
  }

  static isFavorite(key: string): boolean {
    return PreferencesService.loadFavorites().some((r: ConversionRecord) => r.key() === key);
  }

  // ─── Private helpers ───────────────────────────────────────────────────────

  private static parseList(raw: string | undefined): ConversionRecord[] {
    if (!raw) {
      return [];
    }
    try {
      const parsed = JSON.parse(raw) as SerializedRecord[];
      if (!Array.isArray(parsed)) {
        return [];
      }
      return parsed.map((plain: SerializedRecord) => PreferencesService.hydrate(plain));
    } catch (_e) {
      return [];
    }
  }

  private static hydrate(plain: SerializedRecord): ConversionRecord {
    const rec = new ConversionRecord(
      plain.category,
      plain.fromUnit as AnyUnit,
      plain.toUnit as AnyUnit,
      plain.fromValue,
      plain.toValue
    );
    rec.id = plain.id;
    rec.timestamp = plain.timestamp;
    return rec;
  }

  private static persistList(key: string, list: ConversionRecord[]): void {
    AppStorage.setOrCreate<string>(key, JSON.stringify(list));
  }

  private static isSameHistoryRecord(left: ConversionRecord, right: ConversionRecord): boolean {
    return left.category === right.category &&
      left.fromUnit === right.fromUnit &&
      left.toUnit === right.toUnit &&
      left.fromValue === right.fromValue &&
      left.toValue === right.toValue;
  }
}
