import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const levels = ["off", "minimal", "low", "medium", "high", "xhigh", "max"] as const;
type EffortLevel = (typeof levels)[number];

export default function effortExtension(pi: ExtensionAPI) {
	pi.registerCommand("effort", {
		description: "Set the model thinking level",
		getArgumentCompletions: (prefix) => {
			const matches = levels
				.filter((level) => level.startsWith(prefix.toLowerCase()))
				.map((level) => ({ value: level, label: level }));
			return matches.length > 0 ? matches : null;
		},
		handler: async (args, ctx) => {
			const requested = args.trim().toLowerCase();
			let selected: string | undefined = requested || undefined;

			if (!selected) {
				selected = await ctx.ui.select("Effort level", [...levels]);
			}

			if (!selected) return;

			if (!levels.includes(selected as EffortLevel)) {
				ctx.ui.notify(`Unknown effort level: ${selected}`, "error");
				return;
			}

			pi.setThinkingLevel(selected as EffortLevel);
			ctx.ui.notify(`Effort: ${pi.getThinkingLevel()}`, "info");
		},
	});
}
