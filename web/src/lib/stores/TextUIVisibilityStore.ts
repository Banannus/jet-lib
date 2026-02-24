import { writable } from "svelte/store";
import { isEnvBrowser } from "$lib/utils/misc";

const textUIVisibility = writable(isEnvBrowser());

export const textUIVisibilityStore = {
    subscribe: textUIVisibility.subscribe,
    show: () => textUIVisibility.set(true),
    hide: () => textUIVisibility.set(false),
    toggle: (value?: boolean) =>
        textUIVisibility.update((v) => (value !== undefined ? value : !v)),
};
