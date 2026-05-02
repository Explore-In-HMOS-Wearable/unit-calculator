import { AnyUnit } from '../utils/UnitUtils';

let _idCounter: number = 0;

export class ConversionRecord {
  id: string;
  category: string;
  fromUnit: AnyUnit;
  toUnit: AnyUnit;
  fromValue: string;
  toValue: string;
  timestamp: number;

  constructor(
    category: string,
    fromUnit: AnyUnit,
    toUnit: AnyUnit,
    fromValue: string,
    toValue: string
  ) {
    this.category = category;
    this.fromUnit = fromUnit;
    this.toUnit = toUnit;
    this.fromValue = fromValue;
    this.toValue = toValue;
    this.timestamp = Date.now();
    this.id = `${this.timestamp}-${_idCounter++}`;
  }

  key(): string {
    return `${this.category}|${this.fromUnit}|${this.toUnit}|${this.fromValue}|${this.toValue}`;
  }
}
