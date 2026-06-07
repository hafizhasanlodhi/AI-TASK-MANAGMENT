// import { clerkMiddleware, createRouteMatcher } from "@clerk/nextjs/server";

// // Apni AssemblyAI API route ko yahan define karein
// const isPublicRoute = createRouteMatcher(['/api/assemblyai(.*)']);

// export default clerkMiddleware(async (auth, request) => {
//   if (!isPublicRoute(request)) {
//     await auth.protect(); // Naya syntax: 'await' use karein aur 'auth' ke baad () mat lagayein
//   }
// });

// export const config = {
//   matcher: [
//     // Skip Next.js internals and all static files, unless found in search params
//     '/((?!_next|[^?]*\\.(?:html|css|js|gif|svg|jpg|jpeg|png|woff|woff2|ico|csv|docx|xlsx|zip|webmanifest)).*)',
//     // Always run for API routes
//     '/(api|trpc)(.*)',
//   ],
// };


import { clerkMiddleware, createRouteMatcher } from "@clerk/nextjs/server";

// Sign-in, Sign-up aur AssemblyAI routes ko public rakha hai taake redirect loop na bane
const isPublicRoute = createRouteMatcher([
  '/sign-in(.*)', 
  '/sign-up(.*)', 
  '/api/assemblyai(.*)'
]);

export default clerkMiddleware(async (auth, request) => {
  if (!isPublicRoute(request)) {
    await auth.protect(); 
  }
});

export const config = {
  matcher: [
    // Next.js internals aur static files ko skip karne ke liye
    '/((?!_next|[^?]*\\.(?:html|css|js|gif|svg|jpg|jpeg|png|woff|woff2|ico|csv|docx|xlsx|zip|webmanifest)).*)',
    // API aur TRPC routes par hamesha run karne ke liye
    '/(api|trpc)(.*)',
  ],
};

