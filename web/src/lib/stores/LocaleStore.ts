import { writable } from 'svelte/store';
import { fetchNui } from '../utils/fetchNui';
import { loadLocale } from '../utils/locale';

export type Locale = string;

export interface LocaleData {
	locale: Locale;
}

/**
 * Fetches the current locale from the Lua config
 * @returns The locale setting from Config.Lua
 */
export async function fetchLocaleFromConfig(): Promise<Locale> {
	try {
		const data = await fetchNui<LocaleData>('getLocale');
		console.log("Fetched locale from config:", data.locale);
		return data.locale || 'en';
	} catch (error) {
		console.warn('Failed to fetch locale from config (likely not on FiveM server), defaulting to "en"', error);
		return 'en';
	}
}

/**
 * Global store for current locale data
 * Automatically updates when locale changes
 */
export const localesStore = writable<Record<string, any>>({});

/**
 * Creates and initializes the locale system
 * Fetches locale from config and sets up subscriptions
 */
export function createLocaleStore() {
	const localeCodeStore = writable<Locale>('en');

	// Initialize the locale from config
	fetchLocaleFromConfig()
		.then((locale) => {
			console.log("Setting locale to:", locale);
			localeCodeStore.set(locale);
			// Load the locale data
			loadLocale(locale).then((data) => localesStore.set(data));
		})
		.catch((err) => {
			console.error("Failed to set locale:", err);
			localeCodeStore.set('en');
			loadLocale('en').then((data) => localesStore.set(data));
		});

	// Subscribe to locale code changes and load new locale data
	localeCodeStore.subscribe((localeCode) => {
		loadLocale(localeCode).then((data) => localesStore.set(data));
	});

	return {
		subscribe: localeCodeStore.subscribe,
		set: localeCodeStore.set,
	};
}
