export enum LengthUnit {
  MILLIMETER = 'mm',
  CENTIMETER = 'cm',
  METER = 'm',
  KILOMETER = 'km',
  INCH = 'in',
  FOOT = 'ft',
  YARD = 'yd',
  MILE = 'mi'
}

export enum WeightUnit {
  MILLIGRAM = 'mg',
  GRAM = 'g',
  KILOGRAM = 'kg',
  TONNE = 't',
  OUNCE = 'oz',
  POUND = 'lb',
  STONE = 'st'
}

export enum TemperatureUnit {
  CELSIUS = '°C',
  FAHRENHEIT = '°F',
  KELVIN = 'K'
}

export enum VolumeUnit {
  MILLILITER = 'ml',
  LITER = 'l',
  CUBIC_CENTIMETER = 'cc',
  CUBIC_METER = 'm³',
  TEASPOON = 'tsp',
  TABLESPOON = 'tbsp',
  FLUID_OUNCE = 'fl oz',
  CUP = 'cup',
  PINT = 'pt',
  QUART = 'qt',
  GALLON = 'gal'
}

export enum AreaUnit {
  SQUARE_CENTIMETER = 'cm²',
  SQUARE_METER = 'm²',
  SQUARE_KILOMETER = 'km²',
  SQUARE_INCH = 'in²',
  SQUARE_FOOT = 'ft²',
  SQUARE_YARD = 'yd²',
  ACRE = 'ac',
  HECTARE = 'ha'
}

export enum SpeedUnit {
  METER_PER_SECOND = 'm/s',
  KILOMETER_PER_HOUR = 'km/h',
  MILE_PER_HOUR = 'mph',
  FOOT_PER_SECOND = 'ft/s',
  KNOT = 'kn'
}

export enum TimeUnit {
  SECOND = 's',
  MINUTE = 'min',
  HOUR = 'h',
  DAY = 'd',
  WEEK = 'wk',
  MONTH = 'mo',
  YEAR = 'yr'
}

export enum PressureUnit {
  PASCAL = 'Pa',
  KILOPASCAL = 'kPa',
  BAR = 'bar',
  MILLIBAR = 'mbar',
  ATMOSPHERE = 'atm',
  PSI = 'psi',
  TORR = 'torr'
}

export enum EnergyUnit {
  JOULE = 'J',
  KILOJOULE = 'kJ',
  CALORIE = 'cal',
  KILOCALORIE = 'kcal',
  WATT_HOUR = 'Wh',
  KILOWATT_HOUR = 'kWh',
  BTU = 'BTU'
}

export enum PowerUnit {
  WATT = 'W',
  KILOWATT = 'kW',
  HORSEPOWER = 'hp',
  BTU_PER_HOUR = 'BTU/h'
}

export enum AngleUnit {
  DEGREE = '°',
  RADIAN = 'rad',
  GRADIAN = 'gon'
}

// Length units
export const LENGTH_UNITS: LengthUnit[] = [
  LengthUnit.MILLIMETER,
  LengthUnit.CENTIMETER,
  LengthUnit.METER,
  LengthUnit.KILOMETER,
  LengthUnit.INCH,
  LengthUnit.FOOT,
  LengthUnit.YARD,
  LengthUnit.MILE
];

// Weight units
export const WEIGHT_UNITS: WeightUnit[] = [
  WeightUnit.MILLIGRAM,
  WeightUnit.GRAM,
  WeightUnit.KILOGRAM,
  WeightUnit.TONNE,
  WeightUnit.OUNCE,
  WeightUnit.POUND,
  WeightUnit.STONE
];

// Temperature units
export const TEMPERATURE_UNITS: TemperatureUnit[] = [
  TemperatureUnit.CELSIUS,
  TemperatureUnit.FAHRENHEIT,
  TemperatureUnit.KELVIN
];

// Volume units
export const VOLUME_UNITS: VolumeUnit[] = [
  VolumeUnit.MILLILITER,
  VolumeUnit.LITER,
  VolumeUnit.CUBIC_CENTIMETER,
  VolumeUnit.CUBIC_METER,
  VolumeUnit.TEASPOON,
  VolumeUnit.TABLESPOON,
  VolumeUnit.FLUID_OUNCE,
  VolumeUnit.CUP,
  VolumeUnit.PINT,
  VolumeUnit.QUART,
  VolumeUnit.GALLON
];

// Area units
export const AREA_UNITS: AreaUnit[] = [
  AreaUnit.SQUARE_CENTIMETER,
  AreaUnit.SQUARE_METER,
  AreaUnit.SQUARE_KILOMETER,
  AreaUnit.SQUARE_INCH,
  AreaUnit.SQUARE_FOOT,
  AreaUnit.SQUARE_YARD,
  AreaUnit.ACRE,
  AreaUnit.HECTARE
];

// Speed units
export const SPEED_UNITS: SpeedUnit[] = [
  SpeedUnit.METER_PER_SECOND,
  SpeedUnit.KILOMETER_PER_HOUR,
  SpeedUnit.MILE_PER_HOUR,
  SpeedUnit.FOOT_PER_SECOND,
  SpeedUnit.KNOT
];

// Time units
export const TIME_UNITS: TimeUnit[] = [
  TimeUnit.SECOND,
  TimeUnit.MINUTE,
  TimeUnit.HOUR,
  TimeUnit.DAY,
  TimeUnit.WEEK,
  TimeUnit.MONTH,
  TimeUnit.YEAR
];

// Pressure units
export const PRESSURE_UNITS: PressureUnit[] = [
  PressureUnit.PASCAL,
  PressureUnit.KILOPASCAL,
  PressureUnit.BAR,
  PressureUnit.MILLIBAR,
  PressureUnit.ATMOSPHERE,
  PressureUnit.PSI,
  PressureUnit.TORR
];

// Energy units
export const ENERGY_UNITS: EnergyUnit[] = [
  EnergyUnit.JOULE,
  EnergyUnit.KILOJOULE,
  EnergyUnit.CALORIE,
  EnergyUnit.KILOCALORIE,
  EnergyUnit.WATT_HOUR,
  EnergyUnit.KILOWATT_HOUR,
  EnergyUnit.BTU
];

// Power units
export const POWER_UNITS: PowerUnit[] = [
  PowerUnit.WATT,
  PowerUnit.KILOWATT,
  PowerUnit.HORSEPOWER,
  PowerUnit.BTU_PER_HOUR
];

// Angle units
export const ANGLE_UNITS: AngleUnit[] = [
  AngleUnit.DEGREE,
  AngleUnit.RADIAN,
  AngleUnit.GRADIAN
];

// ─────────────────────────────────────────
// NEW CATEGORIES
// ─────────────────────────────────────────

export enum StorageUnit {
  BIT      = 'bit',
  BYTE     = 'B',
  KILOBYTE = 'KB',
  MEGABYTE = 'MB',
  GIGABYTE = 'GB',
  TERABYTE = 'TB',
  PETABYTE = 'PB',
  KIBIBYTE = 'KiB',
  MEBIBYTE = 'MiB',
  GIBIBYTE = 'GiB',
  TEBIBYTE = 'TiB'
}

export enum DataRateUnit {
  BPS  = 'bps',
  KBPS = 'Kbps',
  MBPS = 'Mbps',
  GBPS = 'Gbps',
  TBPS = 'Tbps'
}

export enum FrequencyUnit {
  MILLIHERTZ = 'mHz',
  HERTZ      = 'Hz',
  KILOHERTZ  = 'kHz',
  MEGAHERTZ  = 'MHz',
  GIGAHERTZ  = 'GHz',
  TERAHERTZ  = 'THz'
}

export enum FuelUnit {
  L_PER_100KM = 'L/100km',
  KM_PER_L    = 'km/L',
  MPG_US      = 'mpg',
  MPG_UK      = 'mpg UK'
}

export const STORAGE_UNITS: StorageUnit[] = [
  StorageUnit.BIT,
  StorageUnit.BYTE,
  StorageUnit.KILOBYTE,
  StorageUnit.MEGABYTE,
  StorageUnit.GIGABYTE,
  StorageUnit.TERABYTE,
  StorageUnit.PETABYTE,
  StorageUnit.KIBIBYTE,
  StorageUnit.MEBIBYTE,
  StorageUnit.GIBIBYTE,
  StorageUnit.TEBIBYTE
];

export const DATA_RATE_UNITS: DataRateUnit[] = [
  DataRateUnit.BPS,
  DataRateUnit.KBPS,
  DataRateUnit.MBPS,
  DataRateUnit.GBPS,
  DataRateUnit.TBPS
];

export const FREQUENCY_UNITS: FrequencyUnit[] = [
  FrequencyUnit.MILLIHERTZ,
  FrequencyUnit.HERTZ,
  FrequencyUnit.KILOHERTZ,
  FrequencyUnit.MEGAHERTZ,
  FrequencyUnit.GIGAHERTZ,
  FrequencyUnit.TERAHERTZ
];

export const FUEL_UNITS: FuelUnit[] = [
  FuelUnit.L_PER_100KM,
  FuelUnit.KM_PER_L,
  FuelUnit.MPG_US,
  FuelUnit.MPG_UK
];