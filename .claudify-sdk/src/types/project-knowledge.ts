/**
 * Project Knowledge Schema
 *
 * Represents the extracted conventions, patterns, and domain knowledge
 * from a .NET/Angular project.
 */

export interface ProjectKnowledge {
  /** ISO timestamp when analysis was performed */
  analyzed: string;

  /** Claudify version used for analysis */
  version: string;

  /** Naming conventions used in the project */
  naming: NamingConventions;

  /** Architectural patterns and structure */
  architecture: ArchitectureInfo;

  /** Common patterns used in the codebase */
  patterns: PatternsInfo;

  /** Domain-specific vocabulary and concepts */
  domain: DomainInfo;

  /** Testing conventions and frameworks */
  testing: TestingInfo;
}

export interface NamingConventions {
  /** Class naming pattern (e.g., "PascalCase") */
  classes: string;

  /** Method naming pattern (e.g., "PascalCase") */
  methods: string;

  /** Property naming pattern (e.g., "PascalCase with private setters") */
  properties: string;

  /** Variable naming pattern (e.g., "camelCase") */
  variables: string;

  /** Constant naming pattern (e.g., "UPPER_SNAKE_CASE") */
  constants: string;

  /** Private field naming pattern (e.g., "_camelCase") */
  privateFields: string;

  /** Date field naming convention (e.g., "Use 'On' suffix (CreatedOn)") */
  dateFields: string;

  /** Natural language summary of naming conventions */
  description: string;
}

export interface ArchitectureInfo {
  /** Detected architectural pattern */
  pattern: "DDD" | "Clean" | "Layered" | "N-Tier" | "Custom";

  /** List of architectural layers (e.g., ["Domain", "Application", "Infrastructure"]) */
  layers: string[];

  /** Natural language description of architecture */
  description: string;
}

export interface PatternsInfo {
  /** Entity constructor pattern (e.g., "Private parameterless + factory method") */
  entityConstructors: string;

  /** Collection property pattern (e.g., "IReadOnlyList with private List backing") */
  collectionProperties: string;

  /** Error handling approach (e.g., "Result pattern with Result<T>") */
  errorHandling: string;

  /** Validation approach (e.g., "FluentValidation in constructors") */
  validation: string;

  /** Natural language description of patterns */
  description: string;
}

export interface DomainInfo {
  /** List of domain terms/concepts */
  terms: string[];

  /** List of aggregate root names (if DDD) */
  aggregates: string[];

  /** Natural language description of domain */
  description: string;
}

export interface TestingInfo {
  /** Testing framework (e.g., "xUnit", "NUnit", "MSTest") */
  framework: string;

  /** Test organization pattern (e.g., "AAA (Arrange-Act-Assert)") */
  pattern: string;

  /** Mocking library (e.g., "Moq", "NSubstitute") */
  mockingLibrary: string;

  /** Natural language description of testing approach */
  description: string;
}

/**
 * Analysis options
 */
export interface AnalysisOptions {
  /** Path to the project root */
  projectPath: string;

  /** Path to write the output JSON */
  outputPath: string;

  /** Verbosity level (0 = quiet, 1 = normal, 2 = verbose) */
  verbosity?: number;
}

/**
 * File information returned by file scanner
 */
export interface FileInfo {
  /** Absolute path to the file */
  path: string;

  /** File extension (e.g., ".cs", ".ts") */
  extension: string;

  /** File contents */
  content: string;
}
