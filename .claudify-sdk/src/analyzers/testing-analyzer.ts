import * as path from 'path';
import { FileInfo, TestingInfo } from '../types/project-knowledge';

/**
 * Analyzes testing patterns and frameworks
 *
 * Detects:
 * - Testing framework (xUnit, NUnit, MSTest)
 * - Test organization pattern (AAA, GWT)
 * - Mocking library (Moq, NSubstitute, etc.)
 */
export class TestingAnalyzer {
  async analyze(projectPath: string, csFiles: FileInfo[]): Promise<TestingInfo> {
    // Filter to test files only
    const testFiles = csFiles.filter(f =>
      f.path.toLowerCase().includes('test') ||
      f.path.toLowerCase().includes('spec')
    );

    if (testFiles.length === 0) {
      return {
        framework: 'None detected',
        pattern: 'Unknown',
        mockingLibrary: 'None detected',
        description: 'No test files found in project',
      };
    }

    // Detect framework
    const framework = this.detectFramework(testFiles);

    // Detect test pattern
    const pattern = this.detectPattern(testFiles);

    // Detect mocking library
    const mockingLibrary = this.detectMockingLibrary(testFiles);

    // Generate description
    const description = this.generateDescription(framework, pattern, mockingLibrary);

    return {
      framework,
      pattern,
      mockingLibrary,
      description,
    };
  }

  /**
   * Detect testing framework
   */
  private detectFramework(testFiles: FileInfo[]): string {
    let xunitCount = 0;
    let nunitCount = 0;
    let msTestCount = 0;

    for (const file of testFiles) {
      // xUnit: using Xunit, [Fact], [Theory]
      if (/using\s+Xunit|\[Fact\]|\[Theory\]/.test(file.content)) {
        xunitCount++;
      }

      // NUnit: using NUnit, [Test], [TestFixture]
      if (/using\s+NUnit|\[Test\]|\[TestFixture\]/.test(file.content)) {
        nunitCount++;
      }

      // MSTest: using Microsoft.VisualStudio.TestTools, [TestMethod], [TestClass]
      if (/using\s+Microsoft\.VisualStudio\.TestTools|\[TestMethod\]|\[TestClass\]/.test(file.content)) {
        msTestCount++;
      }
    }

    // Majority wins
    if (xunitCount > nunitCount && xunitCount > msTestCount) {
      return 'xUnit';
    } else if (nunitCount > xunitCount && nunitCount > msTestCount) {
      return 'NUnit';
    } else if (msTestCount > xunitCount && msTestCount > nunitCount) {
      return 'MSTest';
    } else if (xunitCount > 0) {
      return 'xUnit'; // Prefer xUnit as tiebreaker
    } else {
      return 'Unknown';
    }
  }

  /**
   * Detect test organization pattern
   */
  private detectPattern(testFiles: FileInfo[]): string {
    let aaaCommentCount = 0;
    let gwtCommentCount = 0;
    let arrangeActAssertCount = 0;
    let givenWhenThenCount = 0;

    for (const file of testFiles) {
      // Look for AAA comments
      if (/\/\/\s*Arrange|\/\/\s*Act|\/\/\s*Assert/.test(file.content)) {
        aaaCommentCount++;
      }

      // Look for GWT comments
      if (/\/\/\s*Given|\/\/\s*When|\/\/\s*Then/.test(file.content)) {
        gwtCommentCount++;
      }

      // Look for method name patterns
      // AAA: Often method names like "MethodName_Scenario_ExpectedResult"
      if (/(?:Should|When|Given)\w+_\w+_\w+/.test(file.content)) {
        arrangeActAssertCount++;
      }

      // GWT: Often method names like "Given_When_Then"
      if (/Given\w+_When\w+_Then\w+/.test(file.content)) {
        givenWhenThenCount++;
      }
    }

    // Determine pattern
    if (aaaCommentCount > gwtCommentCount && aaaCommentCount > 0) {
      return 'AAA (Arrange-Act-Assert)';
    } else if (gwtCommentCount > aaaCommentCount && gwtCommentCount > 0) {
      return 'GWT (Given-When-Then)';
    } else if (arrangeActAssertCount > 0) {
      return 'AAA (Arrange-Act-Assert)';
    } else if (givenWhenThenCount > 0) {
      return 'GWT (Given-When-Then)';
    } else {
      return 'Various patterns';
    }
  }

  /**
   * Detect mocking library
   */
  private detectMockingLibrary(testFiles: FileInfo[]): string {
    let moqCount = 0;
    let nSubstituteCount = 0;
    let fakeItEasyCount = 0;

    for (const file of testFiles) {
      // Moq: using Moq, Mock<T>
      if (/using\s+Moq|new\s+Mock<|Mock\.Of</.test(file.content)) {
        moqCount++;
      }

      // NSubstitute: using NSubstitute, Substitute.For<T>
      if (/using\s+NSubstitute|Substitute\.For</.test(file.content)) {
        nSubstituteCount++;
      }

      // FakeItEasy: using FakeItEasy, A.Fake<T>
      if (/using\s+FakeItEasy|A\.Fake</.test(file.content)) {
        fakeItEasyCount++;
      }
    }

    // Majority wins
    if (moqCount > nSubstituteCount && moqCount > fakeItEasyCount) {
      return 'Moq';
    } else if (nSubstituteCount > moqCount && nSubstituteCount > fakeItEasyCount) {
      return 'NSubstitute';
    } else if (fakeItEasyCount > moqCount && fakeItEasyCount > nSubstituteCount) {
      return 'FakeItEasy';
    } else if (moqCount > 0) {
      return 'Moq'; // Prefer Moq as tiebreaker (most popular)
    } else {
      return 'None detected';
    }
  }

  /**
   * Generate natural language description
   */
  private generateDescription(
    framework: string,
    pattern: string,
    mockingLibrary: string
  ): string {
    if (framework === 'None detected') {
      return 'No test files found in project';
    }

    const parts: string[] = [];

    parts.push(`Tests written using ${framework}`);

    if (pattern !== 'Various patterns' && pattern !== 'Unknown') {
      parts.push(`organized with ${pattern} pattern`);
    }

    if (mockingLibrary !== 'None detected') {
      parts.push(`using ${mockingLibrary} for mocking`);
    }

    return parts.join(', ') + '.';
  }
}
