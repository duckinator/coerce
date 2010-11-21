/*
 * Based on decadence (https://github.com/nddrylliog/decadence/raw/master/step7/source/Parser.ooc)
 * @author Amos Wenger
 * @author Nick Markwell
 */

import ast/[Node, Expr, Number, BinaryOp, Program, VariableAccess, Assignment, List]

/**
 * Our simple parser that creates an AST
 */
Parser: class {

    path: String
    program: Program
    list: List
    inList := false

    init: func (=path) {
        program = Program new(path)
    }

    parse: func {
        coerceParse(this, path toCString())
    }

    gotNumber: unmangled func (number: CString) -> Number {
        ret := Number new(number toString() toLLong())
        if (inList) list add(ret)
        ret
    }

    gotBinaryOp: unmangled func (type: CString, left, right: Expr) -> BinaryOp {
        ret := BinaryOp new(type toString() clone(), left, right)
        if (inList) list add(ret)
        ret
    }

    gotAssignment: unmangled func (left: CString, right: Expr) -> Assignment {
        ret := Assignment new(left clone() toString(), right)
        if (inList) list add(ret)
        ret
    }

    gotVariableAccess: unmangled func (name: CString) -> VariableAccess {
        ret := VariableAccess new(name toString() clone())
        if (inList) list add(ret)
        ret
    }

    gotExpr: unmangled func (n: Node) {
        if (inList)
            list add(n)
        else
            program body add(n)
    }

    /*gotList: unmangled func (inner: CString) -> List {
        List new(inner toString())
    }*/

    gotListStart: unmangled func {
        list = List new()
        inList = true
    }

    gotListEnd: unmangled func -> List {
        inList = false
        list
    }
}

stringClone: unmangled func (s: CString) -> CString { s clone() }

// coerceParser's prototype
coerceParse: extern proto func (this: Parser, path: CString)

