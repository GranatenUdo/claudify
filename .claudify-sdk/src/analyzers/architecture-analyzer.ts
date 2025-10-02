import * as fs from 'fs';
import * as path from 'path';
import { FileInfo, ArchitectureInfo } from '../types/project-knowledge';

/**
 * Detects architectural patterns from folder structure and code organization
 *
 * Detection approach:
 * 1. Scan folder structure for architectural layer indicators
 * 2. Count occurrences of pattern-specific folders
 * 3. Determine most likely pattern based on evidence
 */
export class ArchitectureAnalyzer {
  async analyze(projectPath: string, csFiles: FileInfo[]): Promise<ArchitectureInfo> {
    // Get all directories in the project
    const directories = this.getAllDirectories(projectPath);

    // Extract folder names (lowercase for comparison)
    const folderNames = directories.map(dir =>
      path.basename(dir).toLowerCase()
    );

    // Score each architecture pattern
    const scores = {
      ddd: this.scoreDDD(folderNames),
      clean: this.scoreClean(folderNames),
      layered: this.scoreLayered(folderNames),
      nTier: this.scoreNTier(folderNames),
    };

    // Determine pattern (highest score wins)
    let pattern: ArchitectureInfo['pattern'] = 'Custom';
    let maxScore = 0;

    for (const [key, score] of Object.entries(scores)) {
      if (score > maxScore) {
        maxScore = score;
        pattern = this.mapToPattern(key);
      }
    }

    // If no clear pattern detected (all scores low), mark as Custom
    if (maxScore < 3) {
      pattern = 'Custom';
    }

    // Detect layers
    const layers = this.detectLayers(folderNames, pattern);

    // Generate description
    const description = this.generateDescription(pattern, layers);

    return {
      pattern,
      layers,
      description,
    };
  }

  /**
   * Get all directories recursively
   */
  private getAllDirectories(dirPath: string): string[] {
    const directories: string[] = [];

    const scan = (currentPath: string, depth: number) => {
      // Limit recursion depth to avoid performance issues
      if (depth > 5) return;

      try {
        const entries = fs.readdirSync(currentPath, { withFileTypes: true });

        for (const entry of entries) {
          if (entry.isDirectory()) {
            const fullPath = path.join(currentPath, entry.name);

            // Skip common directories
            if (this.shouldSkipDirectory(entry.name)) {
              continue;
            }

            directories.push(fullPath);
            scan(fullPath, depth + 1);
          }
        }
      } catch (error) {
        // Ignore permission errors
      }
    };

    scan(dirPath, 0);
    return directories;
  }

  /**
   * Check if directory should be skipped
   */
  private shouldSkipDirectory(name: string): boolean {
    const skipList = [
      'node_modules',
      'bin',
      'obj',
      '.git',
      '.vs',
      '.vscode',
      'dist',
      'build',
    ];

    return skipList.includes(name.toLowerCase());
  }

  /**
   * Score for Domain-Driven Design pattern
   */
  private scoreDDD(folderNames: string[]): number {
    let score = 0;

    // DDD-specific folder names
    const dddIndicators = [
      'domain',
      'aggregates',
      'entities',
      'valueobjects',
      'repositories',
      'domainservices',
      'application',
      'infrastructure',
    ];

    for (const indicator of dddIndicators) {
      // Check if any folder name contains the indicator (not exact match)
      if (folderNames.some(name => name.includes(indicator))) {
        score += 2;
      }
    }

    return score;
  }

  /**
   * Score for Clean Architecture pattern
   */
  private scoreClean(folderNames: string[]): number {
    let score = 0;

    // Clean Architecture layers
    const cleanIndicators = [
      'domain',
      'application',
      'infrastructure',
      'presentation',
      'core',
      'usecases',
    ];

    for (const indicator of cleanIndicators) {
      // Check if any folder name contains the indicator (not exact match)
      if (folderNames.some(name => name.includes(indicator))) {
        score += 2;
      }
    }

    return score;
  }

  /**
   * Score for Layered Architecture
   */
  private scoreLayered(folderNames: string[]): number {
    let score = 0;

    // Layered Architecture indicators
    const layeredIndicators = [
      'businesslogic',
      'business',
      'datalayer',
      'dataaccess',
      'presentationlayer',
      'servicelayer',
      'services',
    ];

    for (const indicator of layeredIndicators) {
      // Check if any folder name contains the indicator (not exact match)
      if (folderNames.some(name => name.includes(indicator))) {
        score += 2;
      }
    }

    return score;
  }

  /**
   * Score for N-Tier Architecture
   */
  private scoreNTier(folderNames: string[]): number {
    let score = 0;

    // N-Tier indicators
    const nTierIndicators = [
      'dal',
      'bll',
      'ui',
      'dataaccess',
      'businesslogic',
      'presentation',
    ];

    for (const indicator of nTierIndicators) {
      // Check if any folder name contains the indicator (not exact match)
      if (folderNames.some(name => name.includes(indicator))) {
        score += 2;
      }
    }

    return score;
  }

  /**
   * Map score key to pattern enum
   */
  private mapToPattern(key: string): ArchitectureInfo['pattern'] {
    const map: Record<string, ArchitectureInfo['pattern']> = {
      ddd: 'DDD',
      clean: 'Clean',
      layered: 'Layered',
      nTier: 'N-Tier',
    };

    return map[key] || 'Custom';
  }

  /**
   * Detect architectural layers based on folder names
   */
  private detectLayers(folderNames: string[], pattern: ArchitectureInfo['pattern']): string[] {
    const layers: string[] = [];

    // Common layer names by pattern
    const layersByPattern: Record<string, string[]> = {
      DDD: ['Domain', 'Application', 'Infrastructure', 'Api'],
      Clean: ['Domain', 'Application', 'Infrastructure', 'Presentation'],
      Layered: ['Presentation', 'Business', 'DataAccess'],
      'N-Tier': ['Presentation', 'BusinessLogic', 'DataAccess'],
      Custom: [],
    };

    const potentialLayers = layersByPattern[pattern] || [];

    // Check which layers exist (substring matching)
    for (const layer of potentialLayers) {
      if (folderNames.some(name => name.includes(layer.toLowerCase()))) {
        layers.push(layer);
      }
    }

    // If no layers detected but we have folders, try generic detection
    if (layers.length === 0) {
      const genericLayers = ['Domain', 'Application', 'Infrastructure', 'Api', 'Core', 'Services'];
      for (const layer of genericLayers) {
        if (folderNames.some(name => name.includes(layer.toLowerCase()))) {
          layers.push(layer);
        }
      }
    }

    return layers;
  }

  /**
   * Generate natural language description
   */
  private generateDescription(pattern: ArchitectureInfo['pattern'], layers: string[]): string {
    const patternDescriptions: Record<string, string> = {
      DDD: 'Domain-Driven Design with aggregates, entities, and repositories',
      Clean: 'Clean Architecture with clear dependency direction and separation of concerns',
      Layered: 'Layered Architecture with presentation, business, and data access layers',
      'N-Tier': 'N-Tier Architecture with physical separation of layers',
      Custom: 'Custom architecture pattern',
    };

    const baseDescription = patternDescriptions[pattern];

    if (layers.length > 0) {
      return `${baseDescription}. Layers detected: ${layers.join(', ')}.`;
    } else {
      return baseDescription;
    }
  }
}
