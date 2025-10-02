import { glob } from 'glob';
import * as fs from 'fs';
import * as path from 'path';
import { FileInfo } from '../types/project-knowledge';

/**
 * Scans project directories for files
 */
export class FileScanner {
  /**
   * Scan for files matching a pattern
   * @param projectPath Root path to scan
   * @param pattern Glob pattern, example: **\/*.cs
   * @returns Array of file information
   */
  async scanFiles(projectPath: string, pattern: string): Promise<FileInfo[]> {
    // Scan with glob, excluding common directories
    const files = await glob(pattern, {
      cwd: projectPath,
      absolute: true,
      ignore: [
        '**/node_modules/**',
        '**/bin/**',
        '**/obj/**',
        '**/dist/**',
        '**/.git/**',
        '**/.vs/**',
        '**/.vscode/**',
      ],
    });

    // Read file contents
    const fileInfos: FileInfo[] = [];

    for (const filePath of files) {
      try {
        const content = fs.readFileSync(filePath, 'utf-8');
        const extension = path.extname(filePath);

        fileInfos.push({
          path: filePath,
          extension,
          content,
        });
      } catch (error) {
        // Skip files that can't be read
        console.warn(`Warning: Could not read file ${filePath}`);
      }
    }

    return fileInfos;
  }
}
