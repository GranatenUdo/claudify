import { FileInfo, DomainInfo } from '../types/project-knowledge';

/**
 * Extracts domain vocabulary and concepts
 *
 * Identifies:
 * - Domain entity names
 * - Aggregate root names (if DDD)
 * - Common domain terms
 */
export class DomainAnalyzer {
  async analyze(csFiles: FileInfo[]): Promise<DomainInfo> {
    // Extract all class names
    const allClasses = this.extractClassNames(csFiles);

    // Filter to likely domain classes (exclude technical classes)
    const domainClasses = this.filterDomainClasses(allClasses);

    // Identify aggregates (classes in Aggregates folder or marked as aggregate roots)
    const aggregates = this.identifyAggregates(csFiles, domainClasses);

    // Extract key terms (unique domain class names)
    const terms = [...new Set(domainClasses)].sort();

    // Generate description
    const description = this.generateDescription(terms, aggregates);

    return {
      terms,
      aggregates,
      description,
    };
  }

  /**
   * Extract all class names from C# files
   */
  private extractClassNames(files: FileInfo[]): string[] {
    const classRegex = /(?:public|internal)\s+(?:abstract|sealed|static|partial)?\s*class\s+([A-Za-z_][A-Za-z0-9_]*)/g;
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
   * Filter to domain classes (exclude technical classes)
   */
  private filterDomainClasses(classes: string[]): string[] {
    const technicalSuffixes = [
      'Controller',
      'Service',
      'Repository',
      'Validator',
      'Mapper',
      'Factory',
      'Builder',
      'Handler',
      'Query',
      'Command',
      'Response',
      'Request',
      'Dto',
      'ViewModel',
      'Model',
      'Configuration',
      'Settings',
      'Options',
    ];

    return classes.filter(className => {
      // Exclude if ends with any technical suffix
      for (const suffix of technicalSuffixes) {
        if (className.endsWith(suffix)) {
          return false;
        }
      }

      // Exclude common base class names
      if (['Entity', 'ValueObject', 'AggregateRoot', 'BaseEntity'].includes(className)) {
        return false;
      }

      return true;
    });
  }

  /**
   * Identify aggregate root classes
   */
  private identifyAggregates(files: FileInfo[], domainClasses: string[]): string[] {
    const aggregates: string[] = [];

    for (const file of files) {
      // Check if file is in Aggregates folder
      const isInAggregatesFolder = file.path.includes('Aggregates') || file.path.includes('aggregates');

      // Check if class inherits from AggregateRoot or has aggregate marker
      const hasAggregateMarker = /:\s*AggregateRoot|:\s*IAggregateRoot|\[AggregateRoot\]/.test(file.content);

      if (isInAggregatesFolder || hasAggregateMarker) {
        // Extract class name from this file
        const classMatch = file.content.match(/(?:public|internal)\s+(?:abstract|sealed)?\s*class\s+([A-Za-z_][A-Za-z0-9_]*)/);
        if (classMatch) {
          const className = classMatch[1];
          // Only include if it's a domain class
          if (domainClasses.includes(className)) {
            aggregates.push(className);
          }
        }
      }
    }

    return [...new Set(aggregates)].sort();
  }

  /**
   * Generate natural language description
   */
  private generateDescription(terms: string[], aggregates: string[]): string {
    if (terms.length === 0) {
      return 'No clear domain model detected';
    }

    const parts: string[] = [];

    // Describe domain size
    if (terms.length <= 5) {
      parts.push('Small domain model');
    } else if (terms.length <= 15) {
      parts.push('Medium-sized domain model');
    } else {
      parts.push('Large domain model');
    }

    // List key terms (first few)
    if (terms.length > 0) {
      const keyTerms = terms.slice(0, Math.min(5, terms.length));
      parts.push(`with entities like ${keyTerms.join(', ')}`);
    }

    // Mention aggregates if detected
    if (aggregates.length > 0) {
      if (aggregates.length === 1) {
        parts.push(`Aggregate root: ${aggregates[0]}`);
      } else {
        parts.push(`${aggregates.length} aggregate roots identified`);
      }
    }

    return parts.join('. ') + '.';
  }
}
