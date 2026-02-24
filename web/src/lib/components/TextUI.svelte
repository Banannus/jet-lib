<script lang="ts">
    // Import Roboto font from Google Fonts
    if (typeof window !== 'undefined' && !document.getElementById('roboto-font')) {
        const link = document.createElement('link');
        link.id = 'roboto-font';
        link.rel = 'stylesheet';
        link.href = 'https://fonts.googleapis.com/css?family=Roboto:400,500,700&display=swap';
        document.head.appendChild(link);
    }
    import { fade } from 'svelte/transition';
    import Icon from "$lib/components/Icon.svelte";
    import { textUIStore } from "$lib/stores/TextUI";

    const positionStyles: Record<string, string> = {
        "top-left":    "top:1rem;left:1rem;right:auto;bottom:auto;transform:none;",
        "top-center":  "top:1rem;left:50%;right:auto;bottom:auto;transform:translateX(-50%);",
        "top-right":   "top:1rem;right:1rem;left:auto;bottom:auto;transform:none;",
        "middle-left": "top:50%;left:1rem;right:auto;bottom:auto;transform:translateY(-50%);",
        "middle-right":"top:50%;right:1rem;left:auto;bottom:auto;transform:translateY(-50%);",
        "bottom-left": "bottom:1rem;left:1rem;right:auto;top:auto;transform:none;",
        "bottom-center":"bottom:1rem;left:50%;right:auto;top:auto;transform:translateX(-50%);",
        "bottom-right":"bottom:1rem;right:1rem;left:auto;top:auto;transform:none;"
    };

    function lightenColor(hex: string, percent: number) {
        hex = hex.replace(/^#/, '');
        if (hex.length === 3) {
            hex = hex.split('').map(x => x + x).join('');
        }
        const num = parseInt(hex, 16);
        let r = (num >> 16) + Math.round((255 - (num >> 16)) * percent);
        let g = ((num >> 8) & 0x00FF) + Math.round((255 - ((num >> 8) & 0x00FF)) * percent);
        let b = (num & 0x0000FF) + Math.round((255 - (num & 0x0000FF)) * percent);

        r = Math.min(255, r);
        g = Math.min(255, g);
        b = Math.min(255, b);

        return `#${((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1)}`;
    }

    $: borderColor = lightenColor($textUIStore?.color ?? "#2A2A2A", 0.07);

    function getIconProps(icon: any): { name: string; color?: string; size?: number; strokeWidth?: number } {
        if (typeof icon === 'object' && icon !== null) {
            return {
                name: icon.name,
                color: icon.color,
                size: icon.size ?? 16,
                strokeWidth: icon.strokeWidth
            };
        }
        return { name: icon, size: 16 };
    }
    $: iconProps = getIconProps($textUIStore?.icon);

    function styleObjectToString(styleObj: Record<string, string | number> = {}) {
        return Object.entries(styleObj)
            .map(([k, v]) => `${k.replace(/([A-Z])/g, '-$1').toLowerCase()}:${v};`)
            .join('');
    }
    $: customStyle = styleObjectToString($textUIStore?.style);

</script>

{#if $textUIStore}
<div class="flex items-center space-x-3" style={`font-family: 'Roboto', sans-serif;${positionStyles[$textUIStore.position] || ""};position: absolute;`} transition:fade={{ duration: 200 }}>
    {#if $textUIStore.keybind}
        <div class="keybind-container" style="background-color: {$textUIStore.color}; border: 2px solid {$textUIStore.keybind.color || borderColor}; color: {$textUIStore.keybind.color || 'white'};">
            <span class="keybind-key">{$textUIStore.keybind.key}</span>
        </div>
    {/if}
    <div class="text-container" style={`background-color:${$textUIStore.color};border:2px solid; border-color:${borderColor};${customStyle}`}>
        <div class="flex items-center space-x-2">
            {#if iconProps.name}
                <Icon {...iconProps} />
            {/if}
            <span class="text-sm text-white">
                {#each $textUIStore.text.split(/\n/g) as line, i (i)}
                    {#if i > 0}<br>{/if}{line}
                {/each}
            </span>
        </div>
    </div>
</div>
{/if}

<style>
    .keybind-container {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 48px;
        height: 48px;
        border-radius: 6px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.4);
        flex-shrink: 0;
    }

    .text-container {
        padding: 12px 16px;
        border-radius: 6px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.4);
        min-height: 48px;
        display: flex;
        align-items: center;
    }

    .keybind-key {
        font-size: 16px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
</style>