/**
 * Simple i18n utility for handling locale/translation strings from a JSON file
 * Usage:
 * - Import translations: import locales from '../../../locales/en.json'
 * - Get string: getLocale(locales, 'ui.button.close')
 */

export type LocaleKeys = Record<string, any>;

// Load all locale files at module level for easy access
const localeModules = import.meta.glob('../../../../locales/*.json', { eager: true });

/**
 * Retrieves a nested locale string using dot notation
 * @param locales The locale object/map
 * @param key The dot-notation key (e.g., 'ui.button.close')
 * @param defaultValue Fallback value if key is not found
 * @returns The locale string or default value
 * 
 * @example
 * const en = { ui: { button: { close: 'Close' } } }
 * getLocale(en, 'ui.button.close') // Returns 'Close'
 * getLocale(en, 'ui.nonexistent', 'N/A') // Returns 'N/A'
 */
export function getLocale(
	locales: LocaleKeys,
	key: string,
	defaultValue: string = key,
): string {
	const keys = key.split(".");
	let current: any = locales;

	for (const k of keys) {
		if (current && typeof current === "object" && k in current) {
			current = current[k];
		} else {
			return defaultValue;
		}
	}

	return typeof current === "string" ? current : defaultValue;
}

/**
 * Retrieves a locale string and replaces placeholders
 * @param locales The locale object/map
 * @param key The dot-notation key
 * @param replacements Object with key-value pairs to replace
 * @param defaultValue Fallback value if key is not found
 * @returns The formatted locale string
 * 
 * @example
 * const en = { greeting: 'Hello, {name}!' }
 * formatLocale(en, 'greeting', { name: 'Alice' }) // Returns 'Hello, Alice!'
 */
export function formatLocale(
	locales: LocaleKeys,
	key: string,
	replacements: Record<string, string | number> = {},
	defaultValue: string = key,
): string {
	let text = getLocale(locales, key, defaultValue);

	Object.entries(replacements).forEach(([placeholder, value]) => {
		text = text.replace(`{${placeholder}}`, String(value));
	});

	return text;
}

/**
 * Dynamically imports a specific locale file
 * @param localeCode The locale code (e.g., 'en', 'da')
 * @returns The locale data object
 * 
 * @example
 * const da = await loadLocale('da');
 * // Returns: { ui: {...}, common: {...} }
 */
export async function loadLocale(localeCode: string): Promise<Record<string, any>> {
	const path = `../../../../locales/${localeCode}.json`;
	const module = localeModules[path] as any;

	if (!module) {
		console.warn(`Locale file not found: ${localeCode}.json`);
		return {};
	}

	return module.default || module;
}
