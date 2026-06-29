import Toybox.Lang;

const STRIKE = 10;

function advanceToTenthFrame(game as Game) as Void {
    for (var idx = 0; idx < 9; idx++) {
        game.AddShot(STRIKE);
    }
}

function compareWoodShots(act as Array<Number?>, exp as Array<Number?>) as Boolean {
    if (act.size() != exp.size()) {
        return false;
    }
    for (var idx = 0; idx < exp.size(); idx++) {
        if (act[idx] != exp[idx]) {
            return false;
        }
    }
    return true;
}

function compareWoodDisplay(act as Array<String>, exp as Array<String>) as Boolean {
    if (act.size() != exp.size()) {
        return false;
    }
    for (var idx = 0; idx < exp.size(); idx++) {
        if (!(act[idx] == null && exp[idx] == null) && !(act[idx].equals(exp[idx]))) {
            return false;
        }
    }
    return true;
}
