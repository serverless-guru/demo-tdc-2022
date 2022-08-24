/// <reference types='node' />

import * as fastify from 'fastify';

declare module 'fastify' {
  interface FastifyRequest {
    /**
     * LP Member Number, Woh Id
     */
    woh_id: string;
    /**
     * Adobe Id
     */
    adobe_id: string;
    /**
     * Hpe's own cookie
     */
    hpe_uid: string;
  }
}
