/*
	Name: ACE_Explosives_fnc_PlaceExplosive

	Author(s):
		Garth de Wet (LH)

	Description:
		Places an explosive at the requested position

	Parameters:
		0: OBJECT - unit
		1: POSITION - Position to place explosive
		2: NUMBER - Rotation
		3: STRING - Magazine class
		4: Config - Config of trigger
		5: ARRAY - variables required for the trigger type

	Returns:
		OBJECT: Placed explosive

	Example:
		_explosive = [player, player modelToWorld [0,0.5, 0.1], 134, "SatchelCharge_Remote_Mag", "Command", []] call ACE_Explosives_fnc_PlaceExplosive;
*/
#include "script_component.hpp"
private ["_pos", "_dir", "_magazineClass", "_ammo", "_triggerSpecificVars", "_unit", "_triggerConfig", "_explosive"];
_unit = _this select 0;
_pos = _this select 1;
_dir = _this select 2;
_magazineClass = _this select 3;
_triggerConfig = _this select 4;
_triggerSpecificVars = _this select 5;
_setDir = true;
if (count _this > 6) then {
	_setDir = _this select 6;
};

if (isNil "_triggerConfig") exitWith {
	diag_log format ["ACE_Explosives: Error config not passed to PlaceExplosive: %1", _this];
	objNull
};

_magazineTrigger = ConfigFile >> "CfgMagazines" >> _magazineClass >> "ACE_Triggers" >> _triggerConfig;
_triggerConfig = ConfigFile >> "CfgACE_Triggers" >> _triggerConfig;

if (isNil "_triggerConfig") exitWith {
	diag_log format ["ACE_Explosives: Error config not found in PlaceExplosive: %1", _this];
	objNull
};

_ammo = getText(ConfigFile >> "CfgMagazines" >> _magazineClass >> "ammo");
if (isText(_magazineTrigger >> "ammo")) then {
	_ammo = getText (_magazineTrigger >> "ammo");
};
_triggerSpecificVars pushBack _triggerConfig;
_explosive = createVehicle [_ammo, _pos, [], 0, "NONE"];
if (isText(_triggerConfig >> "onPlace") && {[_unit,_explosive,_magazineClass,_triggerSpecificVars]
	call compile (getText (_triggerConfig >> "onPlace"))}) exitWith {_explosive};
if (_setDir) then {
	[[_explosive, _dir, getNumber (_magazineTrigger >> "pitch")], QFUNC(setPosition)]
		call EFUNC(common,execRemoteFnc);
};
_explosive
