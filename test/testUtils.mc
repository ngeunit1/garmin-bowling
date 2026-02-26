import Toybox.Lang;

function compareDisplayWoodArray(act as Array<String>, exp as Array<String>) as Boolean {
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