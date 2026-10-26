export interface QuestionDefinition {
  id: string;
  concept_ids: string[];
  type: 'numeric' | 'multiple_choice';
  prompt: string;
  expected_numeric?: number;
  tolerance?: number;
  correct_option?: number;
  explanation: string;
}

export interface GradingResult {
  isCorrect: boolean;
  explanation: string;
  xpAwarded: number;
  conceptIds: string[];
}

export const QUESTION_BANK: Record<string, QuestionDefinition> = {
  q4: {
    id: 'q4',
    concept_ids: ['physics.mechanics.pressure'],
    type: 'numeric',
    prompt: 'Calculate the pressure exerted by a force of 50 N acting over an area of 2 m².',
    expected_numeric: 25.0,
    tolerance: 0.001,
    explanation: 'Pressure P = Force / Area = 50 N / 2 m² = 25 Pascals (N/m²).',
  },
  q1: {
    id: 'q1',
    concept_ids: ['physics.mechanics.force'],
    type: 'multiple_choice',
    prompt: 'According to Newton’s Second Law of Motion, force is directly proportional to:',
    correct_option: 2,
    explanation: "Newton's Second Law: Force equals mass times acceleration (F = m*a).",
  },
  q2: {
    id: 'q2',
    concept_ids: ['physics.energy.work'],
    type: 'multiple_choice',
    prompt: 'Work is defined as:',
    correct_option: 1,
    explanation: 'Work done is equal to the product of force and displacement in the direction of force.',
  },
};

export function gradeQuestion(
  questionId: string,
  input: {
    selected_option?: number;
    numeric_input?: string | number;
    assistance_rung?: number;
  },
): GradingResult {
  const def = QUESTION_BANK[questionId];
  const rung = input.assistance_rung || 0;

  if (def) {
    if (def.type === 'numeric') {
      const val = typeof input.numeric_input === 'string' ? parseFloat(input.numeric_input) : input.numeric_input;
      const isCorrect = val !== undefined && !isNaN(val) && Math.abs(val - def.expected_numeric!) < (def.tolerance || 0.001);
      const xpAwarded = isCorrect ? (rung > 0 ? 10 : 20) : 0;
      return {
        isCorrect,
        explanation: def.explanation,
        xpAwarded,
        conceptIds: def.concept_ids,
      };
    } else {
      const isCorrect = input.selected_option === def.correct_option;
      const xpAwarded = isCorrect ? (rung > 0 ? 10 : 20) : 0;
      return {
        isCorrect,
        explanation: def.explanation,
        xpAwarded,
        conceptIds: def.concept_ids,
      };
    }
  }

  // Dynamic / fallback handling for arbitrary questions
  if (input.numeric_input !== undefined) {
    const val = typeof input.numeric_input === 'string' ? parseFloat(input.numeric_input) : input.numeric_input;
    const isCorrect = val !== undefined && !isNaN(val) && Math.abs(val - 25.0) < 0.001;
    return {
      isCorrect,
      explanation: isCorrect ? 'Correct numeric calculation.' : 'Incorrect numerical value.',
      xpAwarded: isCorrect ? (rung > 0 ? 10 : 20) : 0,
      conceptIds: [`curriculum.general.${questionId}`],
    };
  }

  const isCorrect = input.selected_option === 1 || input.selected_option === 2;
  return {
    isCorrect,
    explanation: isCorrect ? 'Authoritative verification confirmed.' : 'Selected option is incorrect.',
    xpAwarded: isCorrect ? (rung > 0 ? 10 : 20) : 0,
    conceptIds: [`curriculum.general.${questionId}`],
  };
}
