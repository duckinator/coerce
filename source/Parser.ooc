/*
 * Based on decadence (https://github.com/nddrylliog/decadence/raw/master/step7/source/Parser.ooc)
 * @author Amos Wenger
 * @author Nick Markwell
 */

import ast/[Node, Expr, Number, BinaryOp, Program, VariableAccess, Assignment, StringLiteral, CharLiteral, BoolLiteral, List]

/**
 * Our simple parser that creates an AST
 */
Parser: class {

    path: String
    program: Program
    list: List
    currentList: List
    listDepth := 0

    init: func (=path) {
        program = Program new(path)
    }

    parse: func {
        coerceParse(this, path toCString())
    }

    gotNumber: unmangled func (number: CString) -> Number {
        ret := Number new(number toString() toLLong())
        if (listDepth >= 0)
            currentList add(ret)
        else
            program body add(ret)
        ret
    }

    gotBinaryOp: unmangled func (type: CString, left, right: Expr) -> BinaryOp {
        ret := BinaryOp new(type toString() clone(), left, right)
        if (listDepth >= 0)
            currentList add(ret)
        else
            program body add(ret)
        ret
    }

    gotAssignment: unmangled func (left: CString, right: Expr) -> Assignment {
        ret := Assignment new(left clone() toString(), right)
        if (listDepth >= 0 ) Exception new(This, "Assignment in list!") throw()
        program body add(ret)
        ret
    }

    gotVariableAccess: unmangled func (name: CString) -> VariableAccess {
        ret := VariableAccess new(name toString() clone())
        if (listDepth >= 0)
            currentList add(ret)
        else
            program body add(ret)
        ret
    }

    gotExpr: unmangled func (n: Node) {
        if (listDepth >= 0)
            currentList add(n)
        else
            program body add(n)
    }

    gotStringLiteral: unmangled func (s: CString) -> StringLiteral {
        "ohai?" printfln()
        ret := StringLiteral new(s toString() clone())
        "meep" printfln()
        if (listDepth >= 0)
            currentList add(ret)
        else
            program body add(ret)
        ret
    }

    gotCharLiteral: unmangled func (s: CString) -> CharLiteral {
        ret := CharLiteral new(s toString() clone())
        if (listDepth >= 0)
            currentList add(ret)
        else
            program body add(ret)
        ret
    }

    gotBoolLiteral: unmangled func (s: Char) -> BoolLiteral {
        ret := BoolLiteral new(s toString() clone())
        if (listDepth >= 0)
            currentList add(ret)
        else
            program body add(ret)
        ret
    }

    gotListStart: unmangled func {
        if(listDepth == 0) {
            list = List new(null)
        } else {
            tmp := List new(currentList)
            currentList add(tmp)
            currentList = tmp
        }
        listDepth += 1
    }

    gotListEnd: unmangled func -> List {
        listDepth -= 1
        if(listDepth < 0) {
            Exception new(This, "Mismatched parenthesis!") throw()
        }
        tmp := currentList
        currentList = currentList parent
        program body add(tmp)
        tmp
    }
}

stringClone: unmangled func (s: CString) -> CString { s clone() }

// coerceParser's prototype
coerceParse: extern proto func (this: Parser, path: CString)

