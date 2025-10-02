#!/usr/bin/env node

import * as path from 'path';
import * as fs from 'fs';
import { ProjectAnalyzer } from './core/project-analyzer';
import { AnalysisOptions } from './types/project-knowledge';

/**
 * CLI entry point for project analyzer
 */
async function main() {
  const args = process.argv.slice(2);

  // Parse command line arguments
  const options = parseArguments(args);

  if (options.help) {
    showHelp();
    process.exit(0);
  }

  if (!options.projectPath) {
    console.error('Error: --project argument is required');
    showHelp();
    process.exit(1);
  }

  if (!options.outputPath) {
    console.error('Error: --output argument is required');
    showHelp();
    process.exit(1);
  }

  try {
    console.log('🔍 Claudify Project Analyzer v1.0.0');
    console.log('');

    const analyzer = new ProjectAnalyzer();
    await analyzer.analyzeAndSave(options);

    console.log('');
    console.log('✅ Analysis complete!');
    console.log(`📄 Project knowledge saved to: ${options.outputPath}`);
  } catch (error) {
    console.error('');
    console.error('❌ Analysis failed:');
    console.error(error instanceof Error ? error.message : String(error));
    process.exit(1);
  }
}

/**
 * Parse command line arguments
 */
function parseArguments(args: string[]): AnalysisOptions & { help?: boolean } {
  const options: AnalysisOptions & { help?: boolean } = {
    projectPath: '',
    outputPath: '',
    verbosity: 1,
  };

  for (let i = 0; i < args.length; i++) {
    const arg = args[i];

    switch (arg) {
      case '--project':
      case '-p':
        options.projectPath = args[++i];
        break;

      case '--output':
      case '-o':
        options.outputPath = args[++i];
        break;

      case '--verbose':
      case '-v':
        options.verbosity = 2;
        break;

      case '--quiet':
      case '-q':
        options.verbosity = 0;
        break;

      case '--help':
      case '-h':
        options.help = true;
        break;

      default:
        console.error(`Unknown argument: ${arg}`);
        showHelp();
        process.exit(1);
    }
  }

  return options;
}

/**
 * Show help message
 */
function showHelp() {
  console.log(`
Claudify Project Analyzer - Extract conventions and patterns from .NET/Angular projects

Usage:
  claudify-analyze --project <path> --output <path> [options]

Required Arguments:
  --project, -p    Path to the project root directory
  --output, -o     Path to write the output JSON file

Options:
  --verbose, -v    Enable verbose output
  --quiet, -q      Suppress all output except errors
  --help, -h       Show this help message

Examples:
  # Analyze a project and save to .claude/config
  claudify-analyze --project /path/to/repo --output /path/to/repo/.claude/config/project-knowledge.json

  # Verbose mode
  claudify-analyze -p /path/to/repo -o output.json --verbose

For more information, visit: https://github.com/your-org/claudify
  `);
}

// Run CLI
main().catch(error => {
  console.error('Unexpected error:', error);
  process.exit(1);
});
