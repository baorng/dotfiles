type BatteryIconProps = {
    chargePercent: number;
    isCharging: boolean;
    state: "discharging" | "charging" | "full" | "empty" | "unknown";
};

function batteryFillWidth(chargePercent: number): number {
    const clampedCharge = Math.min(100, Math.max(0, chargePercent));
    return 13 * (clampedCharge / 100);
}

export default (props: BatteryIconProps) => (
    <svg class="battery-icon" xmlns="http://www.w3.org/2000/svg" height="20px" viewBox="0 0 24 24" width="20px">
        <path
            class="battery-icon-shell"
            d="M3.75 7.5h14.5a1.75 1.75 0 0 1 1.75 1.75v5.5a1.75 1.75 0 0 1-1.75 1.75H3.75A1.75 1.75 0 0 1 2 14.75v-5.5A1.75 1.75 0 0 1 3.75 7.5Zm17.25 2.75h1.25v3.5H21v-3.5ZM4 9.5v5h14v-5H4Z"
        />
        <rect x="4.5" y="10" width={batteryFillWidth(props.chargePercent)} height="4" rx="1" fill="var(--accent)"/>
        {(props.isCharging || props.state === "charging") && (
            <path class="battery-icon-bolt" d="M11.8 5.5 8.8 12h2.4l-1 6.5 4-8h-2.5l1.1-5Z"/>
        )}
    </svg>
);
