#include "script_component.hpp"

ADDON = false;

PREP(adjustScope);
PREP(canAdjustScope);
PREP(firedEH);
PREP(getOptics);
PREP(hideZeroing);
PREP(inventoryCheck);
PREP(showZeroing);

GVAR(fadeScript) = scriptNull;

ADDON = true;
