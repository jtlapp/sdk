// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/src/error/codes.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../dart/resolution/driver_resolution.dart';

main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(RedirectToNonConstConstructorTest);
  });
}

@reflectiveTest
class RedirectToNonConstConstructorTest extends DriverResolutionTest {
  test_constRedirector_cannotResolveRedirectee() async {
    // No crash when redirectee cannot be resolved.
    await assertErrorsInCode(r'''
class A {
  const factory A.b() = A.a;
}
''', [
      error(CompileTimeErrorCode.REDIRECT_TO_MISSING_CONSTRUCTOR, 34, 3),
    ]);
  }

  test_constRedirector_constRedirectee() async {
    await assertNoErrorsInCode(r'''
class A {
  const A.a();
  const factory A.b() = A.a;
}
''');
  }

  test_constRedirector_constRedirectee_viaInitializer() async {
    await assertNoErrorsInCode(r'''
class A {
  const A.a();
  const A.b() : this.a();
}
''');
  }

  test_constRedirector_nonConstRedirectee() async {
    await assertErrorsInCode(r'''
class A {
  A.a();
  const factory A.b() = A.a;
}
''', [
      error(CompileTimeErrorCode.REDIRECT_TO_NON_CONST_CONSTRUCTOR, 43, 3),
    ]);
  }

  test_constRedirector_nonConstRedirectee_viaInitializer() async {
    await assertErrorsInCode(r'''
class A {
  A.a();
  const A.b() : this.a();
}
''', [
      error(CompileTimeErrorCode.REDIRECT_TO_NON_CONST_CONSTRUCTOR, 40, 1),
    ]);
  }

  test_constRedirector_viaInitializer_cannotResolveRedirectee() async {
    // No crash when redirectee cannot be resolved.
    await assertErrorsInCode(r'''
class A {
  const A.b() : this.a();
}
''', [
      error(CompileTimeErrorCode.REDIRECT_GENERATIVE_TO_MISSING_CONSTRUCTOR, 26,
          8),
    ]);
  }
}
