// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/src/error/codes.dart';
import 'package:analyzer/src/generated/engine.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../dart/resolution/driver_resolution.dart';

main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(MissingDefaultValueForParameterTest);
  });
}

@reflectiveTest
class MissingDefaultValueForParameterTest extends DriverResolutionTest {
  @override
  AnalysisOptionsImpl get analysisOptions => AnalysisOptionsImpl()
    ..contextFeatures = FeatureSet.forTesting(
        sdkVersion: '2.3.0', additionalFeatures: [Feature.non_nullable]);

  test_class_nonNullable_named_optional_default() async {
    await assertNoErrorsInCode('''
void f({int a = 0}) {}
''');
  }

  test_class_nonNullable_named_optional_noDefault() async {
    await assertErrorsInCode('''
void f({int a}) {}
''', [
      error(CompileTimeErrorCode.MISSING_DEFAULT_VALUE_FOR_PARAMETER, 12, 1),
    ]);
  }

  test_class_nonNullable_named_required() async {
    await assertNoErrorsInCode('''
void f({required int a}) {}
''');
  }

  test_class_nonNullable_positional_optional_default() async {
    await assertNoErrorsInCode('''
void f([int a = 0]) {}
''');
  }

  test_class_nonNullable_positional_optional_noDefault() async {
    await assertErrorsInCode('''
void f([int a]) {}
''', [
      error(CompileTimeErrorCode.MISSING_DEFAULT_VALUE_FOR_PARAMETER, 12, 1),
    ]);
  }

  test_class_nonNullable_positional_required() async {
    await assertNoErrorsInCode('''
void f(int a) {}
''');
  }

  test_class_nullable_named_optional_default() async {
    await assertNoErrorsInCode('''
void f({int? a = 0}) {}
''');
  }

  test_class_nullable_named_optional_noDefault() async {
    await assertNoErrorsInCode('''
void f({int? a}) {}
''');
  }

  test_class_nullable_named_optional_noDefault_fieldFormal() async {
    await assertNoErrorsInCode('''
typedef F = T Function<T>(T);
class C {
  F? f;
  C({this.f});
}
''');
  }

  test_class_nullable_named_required() async {
    await assertNoErrorsInCode('''
void f({required int? a}) {}
''');
  }

  test_class_nullable_positional_optional_default() async {
    await assertNoErrorsInCode('''
void f([int? a = 0]) {}
''');
  }

  test_class_nullable_positional_optional_noDefault() async {
    await assertNoErrorsInCode('''
void f([int? a]) {}
''');
  }

  test_class_nullable_positional_required() async {
    await assertNoErrorsInCode('''
void f(int? a) {}
''');
  }

  test_futureOr_nonNullable_nonNullable_named_optional_default() async {
    await assertNoErrorsInCode('''
import 'dart:async';
void f({FutureOr<int> a = 0}) {}
''');
  }

  test_futureOr_nonNullable_nonNullable_named_optional_noDefault() async {
    await assertErrorsInCode('''
import 'dart:async';
void f({FutureOr<int> a}) {}
''', [
      error(CompileTimeErrorCode.MISSING_DEFAULT_VALUE_FOR_PARAMETER, 43, 1),
    ]);
  }

  test_futureOr_nonNullable_nonNullable_named_required() async {
    await assertNoErrorsInCode('''
import 'dart:async';
void f({required FutureOr<int> a}) {}
''');
  }

  test_futureOr_nonNullable_nonNullable_positional_optional_default() async {
    await assertNoErrorsInCode('''
import 'dart:async';
void f([FutureOr<int> a = 0]) {}
''');
  }

  test_futureOr_nonNullable_nonNullable_positional_optional_noDefault() async {
    await assertErrorsInCode('''
import 'dart:async';
void f([FutureOr<int> a]) {}
''', [
      error(CompileTimeErrorCode.MISSING_DEFAULT_VALUE_FOR_PARAMETER, 43, 1),
    ]);
  }

  test_futureOr_nonNullable_nonNullable_positional_required() async {
    await assertNoErrorsInCode('''
import 'dart:async';
void f(FutureOr<int> a) {}
''');
  }

  test_futureOr_nonNullable_nullable_named_optional_default() async {
    await assertNoErrorsInCode('''
import 'dart:async';
void f({FutureOr<int>? a = 0}) {}
''');
  }

  test_futureOr_nonNullable_nullable_named_optional_noDefault() async {
    await assertNoErrorsInCode('''
import 'dart:async';
void f({FutureOr<int>? a}) {}
''');
  }

  test_futureOr_nonNullable_nullable_named_required() async {
    await assertNoErrorsInCode('''
import 'dart:async';
void f({required FutureOr<int>? a}) {}
''');
  }

  test_futureOr_nonNullable_nullable_positional_optional_default() async {
    await assertNoErrorsInCode('''
import 'dart:async';
void f([FutureOr<int>? a = 0]) {}
''');
  }

  test_futureOr_nonNullable_nullable_positional_optional_noDefault() async {
    await assertNoErrorsInCode('''
import 'dart:async';
void f([FutureOr<int>? a]) {}
''');
  }

  test_futureOr_nonNullable_nullable_positional_required() async {
    await assertNoErrorsInCode('''
import 'dart:async';
void f(FutureOr<int>? a) {}
''');
  }

  test_futureOr_nullable_nonNullable_named_optional_default() async {
    await assertNoErrorsInCode('''
import 'dart:async';
void f({FutureOr<int?> a = 0}) {}
''');
  }

  test_futureOr_nullable_nonNullable_named_optional_noDefault() async {
    await assertNoErrorsInCode('''
import 'dart:async';
void f({FutureOr<int?> a}) {}
''');
  }

  test_futureOr_nullable_nonNullable_named_required() async {
    await assertNoErrorsInCode('''
import 'dart:async';
void f({required FutureOr<int?> a}) {}
''');
  }

  test_futureOr_nullable_nonNullable_positional_optional_default() async {
    await assertNoErrorsInCode('''
import 'dart:async';
void f([FutureOr<int?> a = 0]) {}
''');
  }

  test_futureOr_nullable_nonNullable_positional_optional_noDefault() async {
    await assertNoErrorsInCode('''
import 'dart:async';
void f([FutureOr<int?> a]) {}
''');
  }

  test_futureOr_nullable_nonNullable_positional_required() async {
    await assertNoErrorsInCode('''
import 'dart:async';
void f(FutureOr<int?> a) {}
''');
  }

  test_futureOr_nullable_nullable_named_optional_default() async {
    await assertNoErrorsInCode('''
import 'dart:async';
void f({FutureOr<int?>? a = 0}) {}
''');
  }

  test_futureOr_nullable_nullable_named_optional_noDefault() async {
    await assertNoErrorsInCode('''
import 'dart:async';
void f({FutureOr<int?>? a}) {}
''');
  }

  test_futureOr_nullable_nullable_named_required() async {
    await assertNoErrorsInCode('''
import 'dart:async';
void f({required FutureOr<int?>? a}) {}
''');
  }

  test_futureOr_nullable_nullable_positional_optional_default() async {
    await assertNoErrorsInCode('''
import 'dart:async';
void f([FutureOr<int?>? a = 0]) {}
''');
  }

  test_futureOr_nullable_nullable_positional_optional_noDefault() async {
    await assertNoErrorsInCode('''
import 'dart:async';
void f([FutureOr<int?>? a]) {}
''');
  }

  test_futureOr_nullable_nullable_positional_required() async {
    await assertNoErrorsInCode('''
import 'dart:async';
void f(FutureOr<int?>? a) {}
''');
  }

  test_typeParameter_nullable_named_optional_default() async {
    await assertNoErrorsInCode('''
class A<T extends Object?> {
  void f({T? a = null}) {}
}
''');
  }

  test_typeParameter_nullable_named_optional_noDefault() async {
    await assertNoErrorsInCode('''
class A<T extends Object?> {
  void f({T? a}) {}
}
''');
  }

  test_typeParameter_nullable_named_required() async {
    await assertNoErrorsInCode('''
class A<T extends Object?> {
  void f({required T? a}) {}
}
''');
  }

  test_typeParameter_nullable_positional_optional_default() async {
    await assertNoErrorsInCode('''
class A<T extends Object?> {
  void f([T? a = null]) {}
}
''');
  }

  test_typeParameter_nullable_positional_optional_noDefault() async {
    await assertNoErrorsInCode('''
class A<T extends Object?> {
  void f([T? a]) {}
}
''');
  }

  test_typeParameter_nullable_positional_required() async {
    await assertNoErrorsInCode('''
class A<T extends Object?> {
  void f(T? a) {}
}
''');
  }

  test_typeParameter_potentiallyNonNullable_named_required() async {
    await assertNoErrorsInCode('''
class A<T extends Object?> {
  void f({required T a}) {}
}
''');
  }

  test_typeParameter_potentiallyNonNullable_positional_required() async {
    await assertNoErrorsInCode('''
class A<T extends Object?> {
  void f(T a) {}
}
''');
  }
}
