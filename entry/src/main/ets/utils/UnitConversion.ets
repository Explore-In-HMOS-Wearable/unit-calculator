import {
  AngleUnit,
  EnergyUnit,
  PowerUnit,
  PressureUnit,
  SpeedUnit,
  TimeUnit,
  LengthUnit,
  WeightUnit,
  TemperatureUnit,
  VolumeUnit,
  AreaUnit,
  StorageUnit,
  DataRateUnit,
  FrequencyUnit,
  FuelUnit
} from './UnitEnums';

export class UnitConversion {
  // Round to with decimals digit count
  static roundTo(value: number, decimals: number): number {
    const factor = Math.pow(10, decimals);
    return Math.round(value * factor) / factor;
  }

  // LENGTH
  static convertLength(value: number, from: LengthUnit, to: LengthUnit): number {
    const toMeters: Record<LengthUnit, number> = {
      [LengthUnit.MILLIMETER]: 0.001,
      [LengthUnit.CENTIMETER]: 0.01,
      [LengthUnit.METER]: 1,
      [LengthUnit.KILOMETER]: 1000,
      [LengthUnit.INCH]: 0.0254,
      [LengthUnit.FOOT]: 0.3048,
      [LengthUnit.YARD]: 0.9144,
      [LengthUnit.MILE]: 1609.344
    };

    const decimalCount: Record<LengthUnit, number> = {
      [LengthUnit.MILLIMETER]: 2, // e.g. 1.23 mm
      [LengthUnit.CENTIMETER]: 2, // e.g. 1.23 cm
      [LengthUnit.METER]: 4, // e.g. 0.0001 m
      [LengthUnit.KILOMETER]: 6, // e.g. 0.000123 km
      [LengthUnit.INCH]: 3, // e.g. 0.123 in
      [LengthUnit.FOOT]: 3, // e.g. 0.456 ft
      [LengthUnit.YARD]: 3, // e.g. 0.789 yd
      [LengthUnit.MILE]: 6 // e.g. 0.000456 mi
    };

    const meters = value * toMeters[from];
    const converted = meters / toMeters[to];
    return UnitConversion.roundTo(converted, decimalCount[to]);
  }

  // WEIGHT
  static convertWeight(value: number, from: WeightUnit, to: WeightUnit): number {
    const toKg: Record<WeightUnit, number> = {
      [WeightUnit.MILLIGRAM]: 0.000001,
      [WeightUnit.GRAM]: 0.001,
      [WeightUnit.KILOGRAM]: 1,
      [WeightUnit.TONNE]: 1000,
      [WeightUnit.OUNCE]: 0.0283495,
      [WeightUnit.POUND]: 0.453592,
      [WeightUnit.STONE]: 6.35029
    };

    const decimalCount: Record<WeightUnit, number> = {
      [WeightUnit.MILLIGRAM]: 0, // usually integers
      [WeightUnit.GRAM]: 2,
      [WeightUnit.KILOGRAM]: 4,
      [WeightUnit.TONNE]: 6,
      [WeightUnit.OUNCE]: 3,
      [WeightUnit.POUND]: 3,
      [WeightUnit.STONE]: 4
    };

    const kg = value * toKg[from];
    const converted = kg / toKg[to];
    return UnitConversion.roundTo(converted, decimalCount[to]);
  }

  // TEMPERATURE
  static convertTemperature(value: number, from: TemperatureUnit, to: TemperatureUnit): number {
    if (from === to) {
      return value;
    }

    const decimalCount: Record<TemperatureUnit, number> = {
      [TemperatureUnit.CELSIUS]: 2,
      [TemperatureUnit.FAHRENHEIT]: 2,
      [TemperatureUnit.KELVIN]: 2
    };

    let celsius = value;

    if (from === TemperatureUnit.FAHRENHEIT) {
      celsius = (value - 32) * 5 / 9;
    } else if (from === TemperatureUnit.KELVIN) {
      celsius = value - 273.15;
    }

    let result: number;

    if (to === TemperatureUnit.FAHRENHEIT) {
      result = celsius * 9 / 5 + 32;
    } else if (to === TemperatureUnit.KELVIN) {
      result = celsius + 273.15;
    } else {
      result = celsius;
    }

    return UnitConversion.roundTo(result, decimalCount[to]);
  }

  // VOLUME
  static convertVolume(value: number, from: VolumeUnit, to: VolumeUnit): number {
    const toLiters: Record<VolumeUnit, number> = {
      [VolumeUnit.MILLILITER]: 0.001,
      [VolumeUnit.LITER]: 1,
      [VolumeUnit.CUBIC_CENTIMETER]: 0.001,
      [VolumeUnit.CUBIC_METER]: 1000,
      [VolumeUnit.TEASPOON]: 0.00492892,
      [VolumeUnit.TABLESPOON]: 0.0147868,
      [VolumeUnit.FLUID_OUNCE]: 0.0295735,
      [VolumeUnit.CUP]: 0.24,
      [VolumeUnit.PINT]: 0.473176,
      [VolumeUnit.QUART]: 0.946353,
      [VolumeUnit.GALLON]: 3.78541
    };

    const decimalCount: Record<VolumeUnit, number> = {
      [VolumeUnit.MILLILITER]: 1,
      [VolumeUnit.LITER]: 3,
      [VolumeUnit.CUBIC_CENTIMETER]: 1,
      [VolumeUnit.CUBIC_METER]: 6,
      [VolumeUnit.TEASPOON]: 2,
      [VolumeUnit.TABLESPOON]: 2,
      [VolumeUnit.FLUID_OUNCE]: 2,
      [VolumeUnit.CUP]: 2,
      [VolumeUnit.PINT]: 3,
      [VolumeUnit.QUART]: 3,
      [VolumeUnit.GALLON]: 3
    };

    const liters = value * toLiters[from];
    const converted = liters / toLiters[to];
    return UnitConversion.roundTo(converted, decimalCount[to]);
  }

  // AREA
  static convertArea(value: number, from: AreaUnit, to: AreaUnit): number {
    const toSquareMeters: Record<AreaUnit, number> = {
      [AreaUnit.SQUARE_CENTIMETER]: 0.0001,
      [AreaUnit.SQUARE_METER]: 1,
      [AreaUnit.SQUARE_KILOMETER]: 1_000_000,
      [AreaUnit.SQUARE_INCH]: 0.00064516,
      [AreaUnit.SQUARE_FOOT]: 0.092903,
      [AreaUnit.SQUARE_YARD]: 0.836127,
      [AreaUnit.ACRE]: 4046.86,
      [AreaUnit.HECTARE]: 10000
    };

    const decimalCount: Record<AreaUnit, number> = {
      [AreaUnit.SQUARE_CENTIMETER]: 2,
      [AreaUnit.SQUARE_METER]: 4,
      [AreaUnit.SQUARE_KILOMETER]: 6,
      [AreaUnit.SQUARE_INCH]: 2,
      [AreaUnit.SQUARE_FOOT]: 3,
      [AreaUnit.SQUARE_YARD]: 3,
      [AreaUnit.ACRE]: 6,
      [AreaUnit.HECTARE]: 5
    };

    const m2 = value * toSquareMeters[from];
    const converted = m2 / toSquareMeters[to];
    return UnitConversion.roundTo(converted, decimalCount[to]);
  }

  // SPEED
  static convertSpeed(value: number, from: SpeedUnit, to: SpeedUnit): number {
    const toMps: Record<SpeedUnit, number> = {
      [SpeedUnit.METER_PER_SECOND]: 1,
      [SpeedUnit.KILOMETER_PER_HOUR]: 0.277778,
      [SpeedUnit.MILE_PER_HOUR]: 0.44704,
      [SpeedUnit.FOOT_PER_SECOND]: 0.3048,
      [SpeedUnit.KNOT]: 0.514444
    };

    const decimalCount: Record<SpeedUnit, number> = {
      [SpeedUnit.METER_PER_SECOND]: 2,
      [SpeedUnit.KILOMETER_PER_HOUR]: 2,
      [SpeedUnit.MILE_PER_HOUR]: 2,
      [SpeedUnit.FOOT_PER_SECOND]: 2,
      [SpeedUnit.KNOT]: 2
    };

    const mps = value * toMps[from];
    const converted = mps / toMps[to];
    return UnitConversion.roundTo(converted, decimalCount[to]);
  }

  // TIME
  static convertTime(value: number, from: TimeUnit, to: TimeUnit): number {
    const toSeconds: Record<TimeUnit, number> = {
      [TimeUnit.SECOND]: 1,
      [TimeUnit.MINUTE]: 60,
      [TimeUnit.HOUR]: 3600,
      [TimeUnit.DAY]: 86400,
      [TimeUnit.WEEK]: 604800,
      [TimeUnit.MONTH]: 2.628e+6,
      [TimeUnit.YEAR]: 3.154e+7
    };

    const decimalCount: Record<TimeUnit, number> = {
      [TimeUnit.SECOND]: 0,
      [TimeUnit.MINUTE]: 2,
      [TimeUnit.HOUR]: 2,
      [TimeUnit.DAY]: 3,
      [TimeUnit.WEEK]: 3,
      [TimeUnit.MONTH]: 4,
      [TimeUnit.YEAR]: 4
    };

    const seconds = value * toSeconds[from];
    const converted = seconds / toSeconds[to];
    return UnitConversion.roundTo(converted, decimalCount[to]);
  }

  // PRESSURE
  static convertPressure(value: number, from: PressureUnit, to: PressureUnit): number {
    const toPascals: Record<PressureUnit, number> = {
      [PressureUnit.PASCAL]: 1,
      [PressureUnit.KILOPASCAL]: 1000,
      [PressureUnit.BAR]: 100000,
      [PressureUnit.MILLIBAR]: 100,
      [PressureUnit.ATMOSPHERE]: 101325,
      [PressureUnit.PSI]: 6894.76,
      [PressureUnit.TORR]: 133.322
    };

    const decimalCount: Record<PressureUnit, number> = {
      [PressureUnit.PASCAL]: 0,
      [PressureUnit.KILOPASCAL]: 2,
      [PressureUnit.BAR]: 4,
      [PressureUnit.MILLIBAR]: 2,
      [PressureUnit.ATMOSPHERE]: 4,
      [PressureUnit.PSI]: 3,
      [PressureUnit.TORR]: 2
    };

    const pa = value * toPascals[from];
    const converted = pa / toPascals[to];
    return UnitConversion.roundTo(converted, decimalCount[to]);
  }

  // ENERGY
  static convertEnergy(value: number, from: EnergyUnit, to: EnergyUnit): number {
    const toJoules: Record<EnergyUnit, number> = {
      [EnergyUnit.JOULE]: 1,
      [EnergyUnit.KILOJOULE]: 1000,
      [EnergyUnit.CALORIE]: 4.184,
      [EnergyUnit.KILOCALORIE]: 4184,
      [EnergyUnit.WATT_HOUR]: 3600,
      [EnergyUnit.KILOWATT_HOUR]: 3.6e+6,
      [EnergyUnit.BTU]: 1055.06
    };

    const decimalCount: Record<EnergyUnit, number> = {
      [EnergyUnit.JOULE]: 2,
      [EnergyUnit.KILOJOULE]: 4,
      [EnergyUnit.CALORIE]: 2,
      [EnergyUnit.KILOCALORIE]: 3,
      [EnergyUnit.WATT_HOUR]: 3,
      [EnergyUnit.KILOWATT_HOUR]: 6,
      [EnergyUnit.BTU]: 2
    };

    const joules = value * toJoules[from];
    const converted = joules / toJoules[to];
    return UnitConversion.roundTo(converted, decimalCount[to]);
  }

  // POWER
  static convertPower(value: number, from: PowerUnit, to: PowerUnit): number {
    const toWatts: Record<PowerUnit, number> = {
      [PowerUnit.WATT]: 1,
      [PowerUnit.KILOWATT]: 1000,
      [PowerUnit.HORSEPOWER]: 745.7,
      [PowerUnit.BTU_PER_HOUR]: 0.293071
    };

    const decimalCount: Record<PowerUnit, number> = {
      [PowerUnit.WATT]: 2,
      [PowerUnit.KILOWATT]: 4,
      [PowerUnit.HORSEPOWER]: 3,
      [PowerUnit.BTU_PER_HOUR]: 3
    };

    const watts = value * toWatts[from];
    const converted = watts / toWatts[to];
    return UnitConversion.roundTo(converted, decimalCount[to]);
  }

  // ANGLE
  static convertAngle(value: number, from: AngleUnit, to: AngleUnit): number {
    const toDegrees: Record<AngleUnit, number> = {
      [AngleUnit.DEGREE]: 1,
      [AngleUnit.RADIAN]: 180 / Math.PI,
      [AngleUnit.GRADIAN]: 0.9
    };

    const decimalCount: Record<AngleUnit, number> = {
      [AngleUnit.DEGREE]: 2,
      [AngleUnit.RADIAN]: 4,
      [AngleUnit.GRADIAN]: 2
    };

    const degrees = value * toDegrees[from];
    const converted = degrees / toDegrees[to];
    return UnitConversion.roundTo(converted, decimalCount[to]);
  }

  // DIGITAL STORAGE
  // Base unit: byte. Decimal prefixes (KB=1000), Binary prefixes (KiB=1024).
  static convertStorage(value: number, from: StorageUnit, to: StorageUnit): number {
    const toBytes: Record<StorageUnit, number> = {
      [StorageUnit.BIT]:      0.125,
      [StorageUnit.BYTE]:     1,
      [StorageUnit.KILOBYTE]: 1e3,
      [StorageUnit.MEGABYTE]: 1e6,
      [StorageUnit.GIGABYTE]: 1e9,
      [StorageUnit.TERABYTE]: 1e12,
      [StorageUnit.PETABYTE]: 1e15,
      [StorageUnit.KIBIBYTE]: 1024,
      [StorageUnit.MEBIBYTE]: 1048576,
      [StorageUnit.GIBIBYTE]: 1073741824,
      [StorageUnit.TEBIBYTE]: 1099511627776
    };

    const decimalCount: Record<StorageUnit, number> = {
      [StorageUnit.BIT]:      0,
      [StorageUnit.BYTE]:     0,
      [StorageUnit.KILOBYTE]: 2,
      [StorageUnit.MEGABYTE]: 2,
      [StorageUnit.GIGABYTE]: 3,
      [StorageUnit.TERABYTE]: 3,
      [StorageUnit.PETABYTE]: 3,
      [StorageUnit.KIBIBYTE]: 2,
      [StorageUnit.MEBIBYTE]: 2,
      [StorageUnit.GIBIBYTE]: 3,
      [StorageUnit.TEBIBYTE]: 3
    };

    const bytes = value * toBytes[from];
    const converted = bytes / toBytes[to];
    return UnitConversion.roundTo(converted, decimalCount[to]);
  }

  // DATA TRANSFER RATE
  // Base unit: bps (bits per second). All SI decimal prefixes.
  static convertDataRate(value: number, from: DataRateUnit, to: DataRateUnit): number {
    const toBps: Record<DataRateUnit, number> = {
      [DataRateUnit.BPS]:  1,
      [DataRateUnit.KBPS]: 1e3,
      [DataRateUnit.MBPS]: 1e6,
      [DataRateUnit.GBPS]: 1e9,
      [DataRateUnit.TBPS]: 1e12
    };

    const decimalCount: Record<DataRateUnit, number> = {
      [DataRateUnit.BPS]:  0,
      [DataRateUnit.KBPS]: 2,
      [DataRateUnit.MBPS]: 2,
      [DataRateUnit.GBPS]: 3,
      [DataRateUnit.TBPS]: 3
    };

    const bps = value * toBps[from];
    const converted = bps / toBps[to];
    return UnitConversion.roundTo(converted, decimalCount[to]);
  }

  // FREQUENCY
  // Base unit: Hz.
  static convertFrequency(value: number, from: FrequencyUnit, to: FrequencyUnit): number {
    const toHz: Record<FrequencyUnit, number> = {
      [FrequencyUnit.MILLIHERTZ]: 0.001,
      [FrequencyUnit.HERTZ]:      1,
      [FrequencyUnit.KILOHERTZ]:  1e3,
      [FrequencyUnit.MEGAHERTZ]:  1e6,
      [FrequencyUnit.GIGAHERTZ]:  1e9,
      [FrequencyUnit.TERAHERTZ]:  1e12
    };

    const decimalCount: Record<FrequencyUnit, number> = {
      [FrequencyUnit.MILLIHERTZ]: 1,
      [FrequencyUnit.HERTZ]:      2,
      [FrequencyUnit.KILOHERTZ]:  3,
      [FrequencyUnit.MEGAHERTZ]:  4,
      [FrequencyUnit.GIGAHERTZ]:  4,
      [FrequencyUnit.TERAHERTZ]:  6
    };

    const hz = value * toHz[from];
    const converted = hz / toHz[to];
    return UnitConversion.roundTo(converted, decimalCount[to]);
  }

  // FUEL ECONOMY
  // mpg and km/L are inversely related to L/100km — needs special (non-linear) handling.
  static convertFuel(value: number, from: FuelUnit, to: FuelUnit): number {
    if (from === to || value === 0) {
      return value;
    }

    // Step 1: convert to L/100km
    let l100: number;
    if (from === FuelUnit.L_PER_100KM) {
      l100 = value;
    } else if (from === FuelUnit.KM_PER_L) {
      l100 = 100 / value;
    } else if (from === FuelUnit.MPG_US) {
      l100 = 235.215 / value;
    } else {
      l100 = 282.481 / value; // MPG_UK
    }

    // Step 2: convert from L/100km to target
    let result: number;
    if (to === FuelUnit.L_PER_100KM) {
      result = l100;
    } else if (to === FuelUnit.KM_PER_L) {
      result = 100 / l100;
    } else if (to === FuelUnit.MPG_US) {
      result = 235.215 / l100;
    } else {
      result = 282.481 / l100; // MPG_UK
    }

    return UnitConversion.roundTo(result, 2);
  }
}
