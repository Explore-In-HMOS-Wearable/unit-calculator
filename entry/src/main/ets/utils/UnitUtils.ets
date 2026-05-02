import { UnitConversion } from './UnitConversion';
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
  FuelUnit,
  LENGTH_UNITS,
  WEIGHT_UNITS,
  TEMPERATURE_UNITS,
  VOLUME_UNITS,
  AREA_UNITS,
  SPEED_UNITS,
  TIME_UNITS,
  PRESSURE_UNITS,
  ENERGY_UNITS,
  POWER_UNITS,
  ANGLE_UNITS,
  STORAGE_UNITS,
  DATA_RATE_UNITS,
  FREQUENCY_UNITS,
  FUEL_UNITS
} from './UnitEnums';

export type AnyUnit =
  | LengthUnit
  | WeightUnit
  | TemperatureUnit
  | VolumeUnit
  | AreaUnit
  | SpeedUnit
  | TimeUnit
  | PressureUnit
  | EnergyUnit
  | PowerUnit
  | AngleUnit
  | StorageUnit
  | DataRateUnit
  | FrequencyUnit
  | FuelUnit;

interface UnitConverter {
  category: string,
  units: AnyUnit[];
  fn: (value: number, from: AnyUnit, to: AnyUnit) => number;
}

export const converters: UnitConverter[] = [
  {
    category: 'Length',
    units: LENGTH_UNITS,
    fn: (value, from, to) =>
    UnitConversion.convertLength(value, from as LengthUnit, to as LengthUnit)
  },
  {
    category: 'Weight',
    units: WEIGHT_UNITS,
    fn: (value, from, to) =>
    UnitConversion.convertWeight(value, from as WeightUnit, to as WeightUnit)
  },
  {
    category: 'Temperature',
    units: TEMPERATURE_UNITS,
    fn: (value, from, to) =>
    UnitConversion.convertTemperature(value, from as TemperatureUnit, to as TemperatureUnit)
  },
  {
    category: 'Volume',
    units: VOLUME_UNITS,
    fn: (value, from, to) =>
    UnitConversion.convertVolume(value, from as VolumeUnit, to as VolumeUnit)
  },
  {
    category: 'Area',
    units: AREA_UNITS,
    fn: (value, from, to) =>
    UnitConversion.convertArea(value, from as AreaUnit, to as AreaUnit)
  },
  {
    category: 'Speed',
    units: SPEED_UNITS,
    fn: (value, from, to) =>
    UnitConversion.convertSpeed(value, from as SpeedUnit, to as SpeedUnit)
  },
  {
    category: 'Time',
    units: TIME_UNITS,
    fn: (value, from, to) =>
    UnitConversion.convertTime(value, from as TimeUnit, to as TimeUnit)
  },
  {
    category: 'Pressure',
    units: PRESSURE_UNITS,
    fn: (value, from, to) =>
    UnitConversion.convertPressure(value, from as PressureUnit, to as PressureUnit)
  },
  {
    category: 'Energy',
    units: ENERGY_UNITS,
    fn: (value, from, to) =>
    UnitConversion.convertEnergy(value, from as EnergyUnit, to as EnergyUnit)
  },
  {
    category: 'Power',
    units: POWER_UNITS,
    fn: (value, from, to) =>
    UnitConversion.convertPower(value, from as PowerUnit, to as PowerUnit)
  },
  {
    category: 'Angle',
    units: ANGLE_UNITS,
    fn: (value, from, to) =>
    UnitConversion.convertAngle(value, from as AngleUnit, to as AngleUnit)
  },
  {
    category: 'Storage',
    units: STORAGE_UNITS,
    fn: (value, from, to) =>
    UnitConversion.convertStorage(value, from as StorageUnit, to as StorageUnit)
  },
  {
    category: 'Data Rate',
    units: DATA_RATE_UNITS,
    fn: (value, from, to) =>
    UnitConversion.convertDataRate(value, from as DataRateUnit, to as DataRateUnit)
  },
  {
    category: 'Frequency',
    units: FREQUENCY_UNITS,
    fn: (value, from, to) =>
    UnitConversion.convertFrequency(value, from as FrequencyUnit, to as FrequencyUnit)
  },
  {
    category: 'Fuel',
    units: FUEL_UNITS,
    fn: (value, from, to) =>
    UnitConversion.convertFuel(value, from as FuelUnit, to as FuelUnit)
  }
];