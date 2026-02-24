import { writable } from 'svelte/store';
import { loadLocale } from '../utils/locale';

export type Locale = string;

/**
 * Global store for current locale data
 * Automatically updates when locale changes
 */
export const localesStore = writable<Record<string, any>>({});

/**
 * Initializes and updates the locale store
 * @param localeCode The locale code to load (e.g., 'en', 'da')
 */
export async function setCurrentLocale(localeCode: Locale) {
	const localeData = await loadLocale(localeCode);
	localesStore.set(localeData);
}
