import { FileInfo, PatternsInfo } from '../types/project-knowledge';

/**
 * Identifies common coding patterns in C# code
 *
 * Detects patterns like:
 * - Entity constructor patterns
 * - Collection property patterns
 * - Error handling approaches
 * - Validation strategies
 */
export class PatternAnalyzer {
  async analyze(csFiles: FileInfo[]): Promise<PatternsInfo> {
    const entityConstructorPattern = this.detectEntityConstructorPattern(csFiles);
    const collectionPropertyPattern = this.detectCollectionPropertyPattern(csFiles);
    const errorHandlingPattern = this.detectErrorHandlingPattern(csFiles);
    const validationPattern = this.detectValidationPattern(csFiles);

    const description = this.generateDescription({
      entityConstructorPattern,
      collectionPropertyPattern,
      errorHandlingPattern,
      validationPattern,
    });

    return {
      entityConstructors: entityConstructorPattern,
      collectionProperties: collectionPropertyPattern,
      errorHandling: errorHandlingPattern,
      validation: validationPattern,
      description,
    };
  }

  /**
   * Detect entity constructor pattern
   */
  private detectEntityConstructorPattern(files: FileInfo[]): string {
    let privateConstructorCount = 0;
    let publicConstructorCount = 0;
    let factoryMethodCount = 0;

    for (const file of files) {
      // Look for private parameterless constructors
      if (/private\s+\w+\s*\(\s*\)\s*{/.test(file.content)) {
        privateConstructorCount++;
      }

      // Look for public constructors
      if (/public\s+\w+\s*\([^)]*\)\s*{/.test(file.content)) {
        publicConstructorCount++;
      }

      // Look for static factory methods (Create, CreateNew, etc.)
      if (/public\s+static\s+\w+\s+(?:Create|CreateNew|New|Factory)\w*\s*\(/.test(file.content)) {
        factoryMethodCount++;
      }
    }

    // Determine pattern
    if (privateConstructorCount > publicConstructorCount && factoryMethodCount > 0) {
      return 'Private parameterless constructor + static factory method';
    } else if (publicConstructorCount > privateConstructorCount * 2) {
      return 'Public constructors with parameters';
    } else {
      return 'Mixed constructor patterns';
    }
  }

  /**
   * Detect collection property pattern
   */
  private detectCollectionPropertyPattern(files: FileInfo[]): string {
    let readOnlyListCount = 0;
    let publicListCount = 0;
    let privateBackingFieldCount = 0;

    for (const file of files) {
      // Look for IReadOnlyList<T> properties
      const readOnlyMatches = file.content.match(/IReadOnlyList<\w+>/g);
      if (readOnlyMatches) {
        readOnlyListCount += readOnlyMatches.length;
      }

      // Look for public List<T> properties
      const publicListMatches = file.content.match(/public\s+List<\w+>\s+\w+\s*{/g);
      if (publicListMatches) {
        publicListCount += publicListMatches.length;
      }

      // Look for private List<T> backing fields
      const privateBackingMatches = file.content.match(/private\s+(?:readonly\s+)?List<\w+>\s+_\w+/g);
      if (privateBackingMatches) {
        privateBackingFieldCount += privateBackingMatches.length;
      }
    }

    // Determine pattern
    if (readOnlyListCount > publicListCount && privateBackingFieldCount > 0) {
      return 'IReadOnlyList<T> with private List<T> backing field';
    } else if (publicListCount > readOnlyListCount * 2) {
      return 'Public List<T> properties';
    } else if (readOnlyListCount > 0) {
      return 'IReadOnlyList<T> (mixed backing strategies)';
    } else {
      return 'Various collection patterns';
    }
  }

  /**
   * Detect error handling pattern
   */
  private detectErrorHandlingPattern(files: FileInfo[]): string {
    let resultPatternCount = 0;
    let exceptionCount = 0;

    for (const file of files) {
      // Look for Result<T> or Result pattern
      if (/Result<\w+>|class\s+Result\s*{/.test(file.content)) {
        resultPatternCount++;
      }

      // Look for exception throwing
      if (/throw\s+new\s+\w+Exception/.test(file.content)) {
        exceptionCount++;
      }
    }

    // Determine pattern
    if (resultPatternCount > exceptionCount) {
      return 'Result pattern with Result<T>';
    } else if (exceptionCount > resultPatternCount * 2) {
      return 'Exception-based error handling';
    } else if (resultPatternCount > 0) {
      return 'Mixed (Result pattern and exceptions)';
    } else {
      return 'Exception-based error handling';
    }
  }

  /**
   * Detect validation pattern
   */
  private detectValidationPattern(files: FileInfo[]): string {
    let fluentValidationCount = 0;
    let dataAnnotationsCount = 0;
    let manualValidationCount = 0;

    for (const file of files) {
      // Look for FluentValidation
      if (/using\s+FluentValidation|AbstractValidator</.test(file.content)) {
        fluentValidationCount++;
      }

      // Look for DataAnnotations
      if (/\[Required\]|\[MaxLength\]|\[Range\]/.test(file.content)) {
        dataAnnotationsCount++;
      }

      // Look for manual validation (Guard clauses, if checks in constructors)
      if (/if\s*\([^)]*(?:null|string\.IsNullOrEmpty|<=|>=)[^)]*\)\s*(?:throw|return)/.test(file.content)) {
        manualValidationCount++;
      }
    }

    // Determine pattern (can be multiple)
    const patterns: string[] = [];

    if (fluentValidationCount > 0) {
      patterns.push('FluentValidation');
    }

    if (dataAnnotationsCount > 0) {
      patterns.push('DataAnnotations');
    }

    if (manualValidationCount > Math.max(fluentValidationCount, dataAnnotationsCount) * 2) {
      patterns.push('Manual validation in constructors');
    }

    if (patterns.length === 0) {
      return 'Manual validation';
    } else if (patterns.length === 1) {
      return patterns[0];
    } else {
      return patterns.join(' + ');
    }
  }

  /**
   * Generate natural language description
   */
  private generateDescription(patterns: {
    entityConstructorPattern: string;
    collectionPropertyPattern: string;
    errorHandlingPattern: string;
    validationPattern: string;
  }): string {
    const parts: string[] = [];

    parts.push(`Entity constructors: ${patterns.entityConstructorPattern}`);
    parts.push(`Collection properties: ${patterns.collectionPropertyPattern}`);
    parts.push(`Error handling: ${patterns.errorHandlingPattern}`);
    parts.push(`Validation: ${patterns.validationPattern}`);

    return parts.join('. ') + '.';
  }
}
