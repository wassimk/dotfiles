export default {
  defaultBrowser: "Google Chrome",
  handlers: [
    {
      match: (_, options) => options.opener?.name === "Messages",
      browser: "Safari"
    },
    {
      match: (_, options) => options.opener?.name === "Mail",
      browser: "Safari"
    },
    {
      match: ({ url }) => url.host.includes("epicgames.com"),
      browser: "Safari"
    },
    {
      match: ({ url }) => url.host.includes("twitch.tv"),
      browser: "Safari"
    },
    {
      match: ({ url }) => url.host.includes("youtube.com"),
      browser: "Safari"
    },
    {
      match: /^https?:\/\/*.zoom\.(com)|(us)\/j\/.*$/,
      browser: "us.zoom.xos"
    },
    {
      match: 'https://app.asana.com/0/*',
      browser: {
        name: "Asana",
        openInBackground: true,
      },
      url: ({ url }) => {
        return {
          ...url,
          pathname: url.pathname,
          protocol: 'asanadesktop',
          host: '/app',
        };
      },
    }
  ]
};
