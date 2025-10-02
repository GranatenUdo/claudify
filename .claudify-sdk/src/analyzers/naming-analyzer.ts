import { FileInfo, NamingConventions } from '../types/project-knowledge';

/**
 * Analyzes naming conventions in C# and TypeScript code
 *
 * Approach: Uses regex pattern matching to extract declarations,
 * then statistically analyzes patterns to determine conventions.
 */
export class NamingAnalyzer {
  async analyze(csFiles: FileInfo[], tsFiles: FileInfo[]): Promise<NamingConventions> {
    // Analyze C# naming patterns
    const csClasses = this.extractCSharpClasses(csFiles);
    const csMethods = this.extractCSharpMethods(csFiles);
    const csProperties = this.extractCSharpProperties(csFiles);
    const csPrivateFields = this.extractCSharpPrivateFields(csFiles);
    const csConstants = this.extractCSharpConstants(csFiles);
    const csDateFields = this.extractDateFields(csFiles);

    // Detect patterns
    const classPattern = this.detectCasing(csClasses); // Expected: PascalCase
    const methodPattern = this.detectCasing(csMethods); // Expected: PascalCase
    const propertyPattern = this.analyzeProperties(csProperties);
    const privateFieldPattern = this.detectPrivateFieldPattern(csPrivateFields);
    const constantPattern = this.detectConstantPattern(csConstants);
    const dateFieldPattern = this.detectDateFieldPattern(csDateFields);

    // Generate description
    const description = this.generateDescription({
      classPattern,
      methodPattern,
      propertyPattern,
      privateFieldPattern,
      constantPattern,
      dateFieldPattern,
    });

    return {
      classes: classPattern,
      methods: methodPattern,
      properties: propertyPattern,
      variables: 'camelCase', // Standard for C# local variables
      constants: constantPattern,
      privateFields: privateFieldPattern,
      dateFields: dateFieldPattern,
      description,
    };
  }

  /**
   * Extract class names from C# files
   */
  private extractCSharpClasses(files: FileInfo[]): string[] {
    const classRegex = /(?:public|internal|private|protected)?\s*(?:abstract|sealed|static|partial)?\s*class\s+([A-Za-z_][A-Za-z0-9_]*)/g;
    const classes: string[] = [];

    for (const file of files) {
      let match;
      while ((match = classRegex.exec(file.content)) !== null) {
        classes.push(match[1]);
      }
    }

    return classes;
  }

  /**
   * Extract method names from C# files
   */
  private extractCSharpMethods(files: FileInfo[]): string[] {
    // Match method declarations: public/private ReturnType MethodName(
    const methodRegex = /(?:public|private|protected|internal)\s+(?:static\s+)?(?:async\s+)?(?:virtual\s+)?(?:override\s+)?[A-Za-z_<>[\]]+\s+([A-Za-z_][A-Za-z0-9_]*)\s*\(/g;
    const methods: string[] = [];

    for (const file of files) {
      let match;
      while ((match = methodRegex.exec(file.content)) !== null) {
        const methodName = match[1];
        // Filter out keywords and common false positives
        if (!['get', 'set', 'if', 'for', 'while', 'switch'].includes(methodName)) {
          methods.push(methodName);
        }
      }
    }

    return methods;
  }

  /**
   * Extract properties from C# files
   */
  private extractCSharpProperties(files: FileInfo[]): Array<{ name: string; hasPrivateSetter: boolean }> {
    // Match property declarations
    const propertyRegex = /(?:public|protected|internal)\s+[A-Za-z_<>[\]]+\s+([A-Za-z_][A-Za-z0-9_]*)\s*{\s*get;?\s*(private\s+set|set)?;?\s*}/g;
    const properties: Array<{ name: string; hasPrivateSetter: boolean }> = [];

    for (const file of files) {
      let match;
      while ((match = propertyRegex.exec(file.content)) !== null) {
        properties.push({
          name: match[1],
          hasPrivateSetter: match[2]?.includes('private') || false,
        });
      }
    }

    return properties;
  }

  /**
   * Extract private fields from C# files
   */
  private extractCSharpPrivateFields(files: FileInfo[]): string[] {
    // Match private field declarations
    const fieldRegex = /private\s+(?:readonly\s+)?[A-Za-z_<>[\]]+\s+([A-Za-z_][A-Za-z0-9_]*)\s*[=;]/g;
    const fields: string[] = [];

    for (const file of files) {
      let match;
      while ((match = fieldRegex.exec(file.content)) !== null) {
        fields.push(match[1]);
      }
    }

    return fields;
  }

  /**
   * Extract constants from C# files
   */
  private extractCSharpConstants(files: FileInfo[]): string[] {
    // Match const declarations
    const constRegex = /(?:public|private|protected|internal)\s+const\s+[A-Za-z_]+\s+([A-Za-z_][A-Za-z0-9_]*)\s*=/g;
    const constants: string[] = [];

    for (const file of files) {
      let match;
      while ((match = constRegex.exec(file.content)) !== null) {
        constants.push(match[1]);
      }
    }

    return constants;
  }

  /**
   * Extract date/timestamp field names
   */
  private extractDateFields(files: FileInfo[]): string[] {
    // Match properties/fields with DateTime or DateTimeOffset type
    const dateRegex = /(?:public|protected|internal|private)\s+(?:readonly\s+)?(?:DateTime(?:Offset)?)\s+([A-Za-z_][A-Za-z0-9_]*)/g;
    const dateFields: string[] = [];

    for (const file of files) {
      let match;
      while ((match = dateRegex.exec(file.content)) !== null) {
        dateFields.push(match[1]);
      }
    }

    return dateFields;
  }

  /**
   * Detect casing convention (PascalCase, camelCase, etc.)
   */
  private detectCasing(names: string[]): string {
    if (names.length === 0) return 'PascalCase'; // Default

    let pascalCount = 0;
    let camelCount = 0;

    for (const name of names) {
      if (name.length === 0) continue;

      // Check first character
      if (name[0] === name[0].toUpperCase()) {
        pascalCount++;
      } else {
        camelCount++;
      }
    }

    // Majority wins
    if (pascalCount > camelCount) {
      return 'PascalCase';
    } else if (camelCount > pascalCount) {
      return 'camelCase';
    } else {
      return 'PascalCase'; // Default tie-breaker
    }
  }

  /**
   * Analyze property patterns
   */
  private analyzeProperties(properties: Array<{ name: string; hasPrivateSetter: boolean }>): string {
    if (properties.length === 0) return 'PascalCase';

    const privateSetterCount = properties.filter(p => p.hasPrivateSetter).length;
    const percentage = (privateSetterCount / properties.length) * 100;

    if (percentage > 70) {
      return 'PascalCase with private setters';
    } else if (percentage > 30) {
      return 'PascalCase (mixed setter visibility)';
    } else {
      return 'PascalCase with public setters';
    }
  }

  /**
   * Detect private field pattern
   */
  private detectPrivateFieldPattern(fields: string[]): string {
    if (fields.length === 0) return '_camelCase'; // Default

    let underscoreCount = 0;
    let noPrefixCount = 0;
    let mPrefixCount = 0;

    for (const field of fields) {
      if (field.startsWith('_')) {
        underscoreCount++;
      } else if (field.startsWith('m_')) {
        mPrefixCount++;
      } else {
        noPrefixCount++;
      }
    }

    // Majority wins
    if (underscoreCount > noPrefixCount && underscoreCount > mPrefixCount) {
      return '_camelCase';
    } else if (mPrefixCount > underscoreCount && mPrefixCount > noPrefixCount) {
      return 'm_camelCase';
    } else {
      return 'camelCase (no prefix)';
    }
  }

  /**
   * Detect constant naming pattern
   */
  private detectConstantPattern(constants: string[]): string {
    if (constants.length === 0) return 'PascalCase'; // C# default

    let upperSnakeCount = 0;
    let pascalCount = 0;

    for (const constant of constants) {
      if (constant === constant.toUpperCase() && constant.includes('_')) {
        upperSnakeCount++;
      } else if (constant[0] === constant[0].toUpperCase()) {
        pascalCount++;
      }
    }

    if (upperSnakeCount > pascalCount) {
      return 'UPPER_SNAKE_CASE';
    } else {
      return 'PascalCase';
    }
  }

  /**
   * Detect date field naming pattern
   */
  private detectDateFieldPattern(dateFields: string[]): string {
    if (dateFields.length === 0) return 'Use \'At\' suffix (CreatedAt, UpdatedAt)'; // Default

    let atSuffixCount = 0;
    let onSuffixCount = 0;

    for (const field of dateFields) {
      if (field.endsWith('At')) {
        atSuffixCount++;
      } else if (field.endsWith('On')) {
        onSuffixCount++;
      }
    }

    if (onSuffixCount > atSuffixCount) {
      return 'Use \'On\' suffix (CreatedOn, UpdatedOn)';
    } else if (atSuffixCount > 0) {
      return 'Use \'At\' suffix (CreatedAt, UpdatedAt)';
    } else {
      return 'Various date field naming (no consistent suffix)';
    }
  }

  /**
   * Generate natural language description
   */
  private generateDescription(patterns: {
    classPattern: string;
    methodPattern: string;
    propertyPattern: string;
    privateFieldPattern: string;
    constantPattern: string;
    dateFieldPattern: string;
  }): string {
    const parts: string[] = [];

    parts.push(`Classes use ${patterns.classPattern}`);
    parts.push(`methods use ${patterns.methodPattern}`);
    parts.push(`properties use ${patterns.propertyPattern}`);
    parts.push(`private fields use ${patterns.privateFieldPattern}`);

    if (patterns.constantPattern !== 'PascalCase') {
      parts.push(`constants use ${patterns.constantPattern}`);
    }

    parts.push(`Date fields: ${patterns.dateFieldPattern}`);

    return parts.join(', ') + '.';
  }
}
