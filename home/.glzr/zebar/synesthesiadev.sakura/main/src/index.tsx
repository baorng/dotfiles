import './index.css';
import {For, render} from 'solid-js/web';
import {createStore} from 'solid-js/store';
import * as zebar from 'zebar';
import { createPrefersDark } from "@solid-primitives/media";
import CpuIcon from "./components/icons/CpuIcon";
import MemoryIcon from "./components/icons/MemoryIcon";
import {getWeatherName, WeatherIcon} from "./components/icons/WeatherIcon";
import ClockIcon from "./components/icons/ClockIcon";
import {VolumeIcon} from "./components/icons/VolumeIcon";
import {createEffect} from "solid-js";
import {SCREEN_SAFE_AREAS} from "./screen-safe-areas";

const providers = zebar.createProviderGroup({
    audio: {type: 'audio'},
    cpu: {type: 'cpu'},
    battery: {type: 'battery'},
    memory: {type: 'memory'},
    weather: {type: 'weather'},
    media: {type: 'media'},
    network: {type: 'network'},
    date: {type: 'date', formatting: 'EEE d MMM t'},
    glazewm: {type: 'glazewm'},
});

const NOTCHED_MACBOOK_MONITOR_NAMES = /built.?in|color lcd|liquid retina|retina|macbook/i;
const NOTCHED_MACBOOK_ASPECT_MIN = 1.52;
const NOTCHED_MACBOOK_ASPECT_MAX = 1.56;
const NOTCHED_MACBOOK_MIN_WIDTH = 1300;
const NOTCHED_MACBOOK_MAX_WIDTH = 3600;
const NOTCH_MARGIN = 12;

type Rect = {
    x: number;
    y: number;
    width: number;
    height: number;
};

type ScreenSafeArea = {
    name: string;
    frame: Rect;
    auxiliaryTopLeftArea: Rect | null;
    auxiliaryTopRightArea: Rect | null;
};

render(() => <App/>, document.getElementById('root')!);

function App() {
    const [output, setOutput] = createStore(providers.outputMap);
    const isDark = createPrefersDark();

    createEffect(() => {
        if (isDark()) {
            document.body.classList.remove("light");
        } else {
            document.body.classList.add("light");
        }
    });

    function checkWorkspace(workspace: any): boolean {
        return output.glazewm?.focusedWorkspace == workspace;
    }

    function currentMonitor(): any {
        return output.glazewm?.currentMonitor as any;
    }

    function shouldCheckForNotch(): boolean {
        const monitor = currentMonitor();
        if (!monitor) return false;

        const monitorName = String(monitor.name ?? monitor.deviceName ?? "");
        if (NOTCHED_MACBOOK_MONITOR_NAMES.test(monitorName)) return true;

        const width = Number(monitor.width ?? monitor.size?.width);
        const height = Number(monitor.height ?? monitor.size?.height);
        if (!Number.isFinite(width) || !Number.isFinite(height) || height === 0) {
            return false;
        }

        const aspectRatio = width / height;
        return (
            width >= NOTCHED_MACBOOK_MIN_WIDTH &&
            width <= NOTCHED_MACBOOK_MAX_WIDTH &&
            aspectRatio >= NOTCHED_MACBOOK_ASPECT_MIN &&
            aspectRatio <= NOTCHED_MACBOOK_ASPECT_MAX
        );
    }

    function matchingScreenSafeArea(): ScreenSafeArea | undefined {
        const monitor = currentMonitor();
        if (!monitor || !shouldCheckForNotch()) return undefined;

        const monitorName = String(monitor.name ?? monitor.deviceName ?? "");
        const width = Number(monitor.width ?? monitor.size?.width);
        const height = Number(monitor.height ?? monitor.size?.height);

        return SCREEN_SAFE_AREAS.find((screen) => {
            const nameMatches = screen.name === monitorName;
            const sizeMatches = screen.frame.width === width && screen.frame.height === height;
            return nameMatches || sizeMatches;
        }) as ScreenSafeArea | undefined;
    }

    function notchBounds(): { left: number; right: number } | null {
        const screen = matchingScreenSafeArea();
        if (!screen?.auxiliaryTopLeftArea || !screen.auxiliaryTopRightArea) {
            return null;
        }

        const left = screen.auxiliaryTopLeftArea.x + screen.auxiliaryTopLeftArea.width - screen.frame.x;
        const right = screen.auxiliaryTopRightArea.x - screen.frame.x;
        if (right <= left) return null;

        return { left, right };
    }

    function notchCssVariables(): string | undefined {
        const bounds = notchBounds();
        if (!bounds) return undefined;

        return `--notch-left: ${bounds.left}px; --notch-right: ${bounds.right}px; --notch-margin: ${NOTCH_MARGIN}px;`;
    }

    function shouldDodgeNotch(): boolean {
        return notchBounds() !== null;
    }

    providers.onOutput(outputMap => setOutput(outputMap));

    return (
        <div class="app">
            {output.glazewm && (
                <div class="debug bar-row fill-flow direction-horizontal relative-x pad-5 spacing-10">

                    {/* LEFT SECTION: flex-fill + anchor-centre-left */}
                    <div class="flex-fill anchor-centre-left">
                        <div class="debug fill-flow spacing-5 group-container">
                            <For each={output.glazewm.currentWorkspaces}>
                                {(workspace) => (
                                    <div
                                        class={`debug anchor-centre workspace-container ${checkWorkspace(workspace) ? 'workspace-active' : ''}`}>
                                        <p>•</p>
                                    </div>
                                )}
                            </For>
                        </div>
                    </div>

                    {/* CENTER SECTION: flex-fill + anchor-centre */}
                    <div
                        class={`flex-fill anchor-centre spacing-10 ${shouldDodgeNotch() ? 'notch-dodge' : ''}`}
                        style={notchCssVariables()}
                    >
                        {output.weather && (
                            <div class="debug center-widget notch-left-widget group-container anchor-centre extra-padding">
                                <WeatherIcon status={output.weather.status}/>
                                <p class="pad-5-lr">{getWeatherName(output.weather.status)} {isDark} </p>
                            </div>
                        )}
                        <div class="debug center-widget notch-right-widget group-container anchor-centre extra-padding">
                            <ClockIcon/>
                            <p class="pad-5-lr">{output.date?.formatted}</p>
                        </div>
                    </div>

                    {/* RIGHT SECTION: flex-fill + anchor-centre-right */}
                    <div class="flex-fill anchor-centre-right spacing-10">
                        {output.audio && (
                            <div class="debug group-container anchor-centre extra-padding">
                                <VolumeIcon volumePercentage={output.audio.defaultPlaybackDevice.volume}
                                            isMuted={output.audio.defaultPlaybackDevice.isMuted}/>
                                <p class="pad-5-lr">Volume: {output.audio.defaultPlaybackDevice.volume}%</p>
                            </div>
                        )}
                        {output.cpu && (
                            <div class="debug group-container anchor-centre extra-padding">
                                <CpuIcon/>
                                <p class="pad-5-lr">CPU: {output.cpu.usage.toFixed()}%</p>
                            </div>
                        )}
                        {output.memory && (
                            <div class="debug group-container anchor-centre extra-padding">
                                <MemoryIcon/>
                                <p class="pad-5-lr">Memory: {output.memory.usage.toFixed()}%</p>
                            </div>
                        )}
                    </div>

                </div>
            )}
        </div>
    );
}
