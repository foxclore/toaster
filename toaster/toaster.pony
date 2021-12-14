class Toaster
    let env: Env
    var _passed: U128
    var _failed: U128
    var _passed_names: Array[String]
    var _failed_names: Array[String]

    new create(env': Env) =>
        env = env'
        _passed = 0
        _failed = 0
        _passed_names = Array[String](1)
        _failed_names = Array[String](1)

    fun assert[A: Equatable[A] #read](value_occured: A, value_expected: A): Bool => 
        value_occured == value_expected
        
    fun assert_not[A: Equatable[A] #read](value_occured: A, value_expected: A): Bool =>
        value_occured != value_expected

    fun ref add_test[A: Equatable[A] #read](value_occured: A, value_expected: A, testname: String) =>
        if assert[A](value_occured, value_expected) then
            _passed = _passed + 1
            _passed_names.push(testname)
        else
            _failed = _failed + 1
            _failed_names.push(testname)
        end

    fun ref add_neg_test[A: Equatable[A] #read](value_occured: A, value_expected: A, testname: String) =>
        if assert_not[A](value_occured, value_expected) then
            _passed = _passed + 1
            _passed_names.push(testname)
        else
            _failed = _failed + 1
            _failed_names.push(testname)
        end

    fun results() =>
        env.out.print("Total: " + _passed.string() + "/" + (_passed + _failed).string())
        if _failed == 0 then
            env.out.print("All tests passed!")
        else
            env.out.print("Failed:")
            for element in _failed_names.values() do
                env.out.print("  " + element)
            end
        end