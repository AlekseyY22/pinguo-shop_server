import 'express-session';

declare module 'express-session' {
  interface SissionData {
    userId: string;
  }
}
