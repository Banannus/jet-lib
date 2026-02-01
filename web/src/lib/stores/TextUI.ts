import { writable } from 'svelte/store';

export interface TextUIIcon {
    name: string;
    color?: string;
    size?: number;
    [key: string]: any;
}

export interface TextUIStyle {
    [key: string]: string | number;
}

export interface TextUIData {
    position: 'top-left' | 'top-right' | 'bottom-left' | 'bottom-right' | 'middle-left' | 'middle-right';
    icon?: string | TextUIIcon;
    color: string;
    text: string;
    style?: TextUIStyle;
}

export const textUIStore = writable<TextUIData>({
    position: 'middle-right',
    icon: undefined,
    color: '#2A2A2A',
    text: '',
    style: {},
});