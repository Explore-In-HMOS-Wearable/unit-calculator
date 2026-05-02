import { AnyUnit, converters } from '../utils/UnitUtils';
import { LENGTH_UNITS } from '../utils/UnitEnums';

const DEFAULT_DECIMAL_PRECISION = 4;

export class ConversionService {
  static getCategories(): string[] {
    return converters.map((c) => c.category);
  }

  static getUnitsForCategory(category: string): AnyUnit[] {
    const entry = converters.find((c) => c.category === category);
    return entry?.units ?? LENGTH_UNITS;
  }

  static findCategoryFor(fromUnit: AnyUnit, toUnit: AnyUnit): string | undefined {
    const entry = converters.find((c) =>
      c.units.includes(fromUnit) && c.units.includes(toUnit)
    );
    return entry?.category;
  }

  static getDefaultsForCategory(category: string): [AnyUnit, AnyUnit] {
    const units = ConversionService.getUnitsForCategory(category);
    return [units[0], units[1] ?? units[0]];
  }

  static convert(value: number, fromUnit: AnyUnit, toUnit: AnyUnit): number {
    const entry = converters.find((c) =>
      c.units.includes(fromUnit) && c.units.includes(toUnit)
    );
    if (!entry) {
      return value;
    }
    try {
      return entry.fn(value, fromUnit, toUnit);
    } catch (_e) {
      return value;
    }
  }

  static formatResult(value: number): string {
    if (!isFinite(value)) {
      return '—';
    }
    const abs = Math.abs(value);
    if (abs !== 0 && (abs < 1e-4 || abs >= 1e9)) {
      return value.toExponential(DEFAULT_DECIMAL_PRECISION);
    }
    let str = value.toFixed(DEFAULT_DECIMAL_PRECISION);
    // Strip trailing zeros after decimal point
    if (str.includes('.')) {
      str = str.replace(/\.?0+$/, '');
    }
    // Add thousand separators to integer part
    const parts = str.split('.');
    parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    return parts.join('.');
  }
}
