/* 		
			file: fn_robShops.sqf
			Author: Corey
			Edits: Benkahoots
			Parts of Script: www.altisliferpg.com
			Description:
			Enables the Rob Shop action
 
*/ 
private["_player","_store","_random","_robcash"];
_player = _this select 0;
_store = _this select 1;
_random = floor(random 19);
_robcash = [];
	
waitUntil{!isNull (findDisplay 38200)}; //Wait for the spawn selection to be open.
_store setVariable ["robProgress",true,false];
waitUntil{isNull (findDisplay 38200)}; //Wait for the spawn selection to be done.

if(life_can_rob_gas_station) then
{
	if(vehicle player == _robber && {alive _robber} && {currentWeapon _robber != ""}) then
	{
		if(vehicle player != _robber) exitWith { hint "You can't rob a station from your car. Noob..."; };
		hint format ["%1 seconds remaining - safe is being opened - stand by!",_timer];
		while {_timer > 0} do
		{
			sleep 1;
			_timer = _timer - 1;
			_dist = _robber distance _shopID;
			if(!alive _robber) exitWith
			{
				hint "You failed because you died!";
			};
			if(_dist > 3) exitWith
			{
				hint "You failed because you chickened out!";
			};
		};
		life_cash = life_cash + _funds;
		hint format["You have robbed the gas station of $%1 and have been added to the wanted list!",_funds];
		[[format["%1 is robbing the %2 gas station. They have been added to the wanted list!",name player,_shopID],"Anonymous Tipper",1],"clientMessage",true,false] spawn life_fnc_MP;
		[[getPlayerUID _robber,name _robber,"211"],"life_fnc_wantedAdd",false,false] spawn life_fnc_MP;

		[] spawn
		{
			life_can_rob_gas_station = false;
			sleep 420;
			life_can_rob_gas_station = true;
		};
	};
}
else
{
	hint "You recently robbed a gas station, and must wait to rob another.";
};

if (_random == 2) then
	{
	hint "apu fought back and has gunned you down";
	[[1,format["%1 tried to rob apu but was gunned down",name _player],"life_fnc_broadcast",nil,false] spawn life_fnc_MP;
	sleep 2;
	_player setDamage 1;
	};
if (_random =< 4) && (_random != 2) then // add 5 * each item shop has instead of cash
if (_random > 4) then _robcash = (_random * 1000);
if (_robcash > 999) then life_cash = life_cash + _robcash;
_store setVariable ["robProgress",false,false];
