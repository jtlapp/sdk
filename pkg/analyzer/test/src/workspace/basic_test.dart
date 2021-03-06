// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/file_system/file_system.dart';
import 'package:analyzer/src/context/builder.dart';
import 'package:analyzer/src/test_utilities/resource_provider_mixin.dart';
import 'package:analyzer/src/workspace/basic.dart';
import 'package:package_config/packages.dart';
import 'package:test/test.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../../generated/test_support.dart';

main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(BasicWorkspaceTest);
    defineReflectiveTests(BasicWorkspacePackageTest);
  });
}

@reflectiveTest
class BasicWorkspacePackageTest with ResourceProviderMixin {
  BasicWorkspace workspace;

  setUp() {
    final contextBuilder = MockContextBuilder();
    final packages = MockPackages();
    final packageMap = <String, List<Folder>>{'project': []};
    contextBuilder.packagesMapMap[convertPath('/workspace')] = packages;
    contextBuilder.packagesToMapMap[packages] = packageMap;

    newFolder('/workspace');
    workspace = BasicWorkspace.find(
        resourceProvider, convertPath('/workspace'), contextBuilder);
    expect(workspace.isBazel, isFalse);
  }

  void test_contains_differentWorkspace() {
    newFile('/workspace2/project/lib/file.dart');

    var package = workspace
        .findPackageFor(convertPath('/workspace/project/lib/code.dart'));
    expect(
        package.contains(
            TestSource(convertPath('/workspace2/project/lib/file.dart'))),
        isFalse);
  }

  void test_contains_sameWorkspace() {
    newFile('/workspace/project/lib/file2.dart');

    var package = workspace
        .findPackageFor(convertPath('/workspace/project/lib/code.dart'));
    expect(
        package.contains(
            TestSource(convertPath('/workspace/project/lib/file2.dart'))),
        isTrue);
    expect(
        package.contains(
            TestSource(convertPath('/workspace/project/bin/bin.dart'))),
        isTrue);
    expect(
        package.contains(
            TestSource(convertPath('/workspace/project/test/test.dart'))),
        isTrue);
  }

  void test_findPackageFor_includedFile() {
    newFile('/workspace/project/lib/file.dart');

    var package = workspace
        .findPackageFor(convertPath('/workspace/project/lib/file.dart'));
    expect(package, isNotNull);
    expect(package.root, convertPath('/workspace'));
    expect(package.workspace, equals(workspace));
  }

  void test_findPackageFor_unrelatedFile() {
    newFile('/workspace/project/lib/file.dart');

    var package = workspace
        .findPackageFor(convertPath('/workspace2/project/lib/file.dart'));
    expect(package, isNull);
  }
}

@reflectiveTest
class BasicWorkspaceTest with ResourceProviderMixin {
  setUp() {
    newFolder('/workspace');
  }

  void test_find_directory() {
    BasicWorkspace workspace = BasicWorkspace.find(
        resourceProvider, convertPath('/workspace'), MockContextBuilder());
    expect(workspace.root, convertPath('/workspace'));
    expect(workspace.isBazel, isFalse);
  }

  void test_find_fail_notAbsolute() {
    expect(
        () => BasicWorkspace.find(resourceProvider, convertPath('not_absolute'),
            MockContextBuilder()),
        throwsA(TypeMatcher<ArgumentError>()));
  }

  void test_find_file() {
    BasicWorkspace workspace = BasicWorkspace.find(resourceProvider,
        convertPath('/workspace/project/lib/lib1.dart'), MockContextBuilder());
    expect(workspace.root, convertPath('/workspace/project/lib'));
    expect(workspace.isBazel, isFalse);
  }
}

class MockContextBuilder implements ContextBuilder {
  Map<String, Packages> packagesMapMap = <String, Packages>{};
  Map<Packages, Map<String, List<Folder>>> packagesToMapMap =
      <Packages, Map<String, List<Folder>>>{};

  Map<String, List<Folder>> convertPackagesToMap(Packages packages) =>
      packagesToMapMap[packages];

  Packages createPackageMap(String rootDirectoryPath) =>
      packagesMapMap[rootDirectoryPath];

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockPackages implements Packages {
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
