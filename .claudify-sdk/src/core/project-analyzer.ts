import * as fs from 'fs';
import * as path from 'path';
import { ProjectKnowledge, AnalysisOptions } from '../types/project-knowledge';
import { NamingAnalyzer } from '../analyzers/naming-analyzer';
import { ArchitectureAnalyzer } from '../analyzers/architecture-analyzer';
import { PatternAnalyzer } from '../analyzers/pattern-analyzer';
import { DomainAnalyzer } from '../analyzers/domain-analyzer';
import { TestingAnalyzer } from '../analyzers/testing-analyzer';
import { FileScanner } from './file-scanner';

/**
 * Main project analyzer that orchestrates all sub-analyzers
 */
export class ProjectAnalyzer {
  private fileScanner: FileScanner;
  private namingAnalyzer: NamingAnalyzer;
  private architectureAnalyzer: ArchitectureAnalyzer;
  private patternAnalyzer: PatternAnalyzer;
  private domainAnalyzer: DomainAnalyzer;
  private testingAnalyzer: TestingAnalyzer;

  constructor() {
    this.fileScanner = new FileScanner();
    this.namingAnalyzer = new NamingAnalyzer();
    this.architectureAnalyzer = new ArchitectureAnalyzer();
    this.patternAnalyzer = new PatternAnalyzer();
    this.domainAnalyzer = new DomainAnalyzer();
    this.testingAnalyzer = new TestingAnalyzer();
  }

  /**
   * Analyze a project and extract conventions and patterns
   */
  async analyze(options: AnalysisOptions): Promise<ProjectKnowledge> {
    const { projectPath, verbosity = 1 } = options;

    this.log(`Analyzing project at: ${projectPath}`, verbosity, 1);

    // Validate project path
    if (!fs.existsSync(projectPath)) {
      throw new Error(`Project path does not exist: ${projectPath}`);
    }

    // Scan for C# and TypeScript files
    this.log('Scanning for C# and TypeScript files...', verbosity, 1);
    const csFiles = await this.fileScanner.scanFiles(projectPath, '**/*.cs');
    const tsFiles = await this.fileScanner.scanFiles(projectPath, '**/*.ts');

    this.log(`Found ${csFiles.length} C# files and ${tsFiles.length} TypeScript files`, verbosity, 1);

    // Run all analyzers
    this.log('Analyzing naming conventions...', verbosity, 1);
    const naming = await this.namingAnalyzer.analyze(csFiles, tsFiles);

    this.log('Detecting architecture...', verbosity, 1);
    const architecture = await this.architectureAnalyzer.analyze(projectPath, csFiles);

    this.log('Identifying patterns...', verbosity, 1);
    const patterns = await this.patternAnalyzer.analyze(csFiles);

    this.log('Extracting domain vocabulary...', verbosity, 1);
    const domain = await this.domainAnalyzer.analyze(csFiles);

    this.log('Analyzing testing patterns...', verbosity, 1);
    const testing = await this.testingAnalyzer.analyze(projectPath, csFiles);

    // Read version from Claudify VERSION file
    const versionPath = path.join(__dirname, '..', '..', '..', 'VERSION');
    let version = '4.0.0'; // default
    if (fs.existsSync(versionPath)) {
      version = fs.readFileSync(versionPath, 'utf-8').trim();
    }

    const knowledge: ProjectKnowledge = {
      analyzed: new Date().toISOString(),
      version,
      naming,
      architecture,
      patterns,
      domain,
      testing,
    };

    this.log('Analysis complete!', verbosity, 1);

    return knowledge;
  }

  /**
   * Analyze and save to file
   */
  async analyzeAndSave(options: AnalysisOptions): Promise<void> {
    const knowledge = await this.analyze(options);

    const { outputPath, verbosity = 1 } = options;

    // Ensure output directory exists
    const outputDir = path.dirname(outputPath);
    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }

    // Write to file
    fs.writeFileSync(outputPath, JSON.stringify(knowledge, null, 2), 'utf-8');

    this.log(`Project knowledge saved to: ${outputPath}`, verbosity, 1);
  }

  private log(message: string, currentVerbosity: number, requiredVerbosity: number): void {
    if (currentVerbosity >= requiredVerbosity) {
      console.log(message);
    }
  }
}
