/*
 * Based on decadence (https://github.com/nddrylliog/decadence/raw/master/step7/source/ast/Number.ooc)
 * @author Amos Wenger
 * @author Nick Markwell
 */

import Expr, Visitor

/**
 * Represents a number literal
 */
Number: class extends Expr {

    value: LLong

    init: func (=value) {}

    toString: func -> String {
        value toString()
    }

    accept: func (v: Visitor) {
        v visitNumber(this)
    }

}

