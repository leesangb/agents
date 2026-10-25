# TypeScript Patterns

These self-contained examples illustrate the skill's contracts. Apply the project's own names, schema library, and runtime failure policy.

## Value-Producing Transformations

Preserve the distinction between missing and empty values. A direct transformation avoids a separately mutated result array.

```ts
type User = { name: string; nickname?: string; active: boolean };

const displayName = (user: User) => user.nickname ?? user.name;
const activeNames = (users: readonly User[]) =>
  users.filter((user) => user.active).map(displayName);
```

Use a loop when it states the actual behavior more clearly. Immutability does not justify a dense expression or a costly repeated copy.

## Inferred Result Variants and Exhaustiveness

Check each variant without replacing the function's inferred union. Here callers retain both denied reasons and exhaust all outcome kinds.

```ts
type User = { active: boolean; role?: { scopes: readonly string[] } };
type PermissionResult =
  | { kind: "allowed"; scopes: readonly string[] }
  | { kind: "denied"; reason: "inactive" | "missing-role" };

const evaluatePermission = (user: User) => {
  if (!user.active) {
    return { kind: "denied", reason: "inactive" } satisfies PermissionResult;
  }
  if (!user.role) {
    return { kind: "denied", reason: "missing-role" } satisfies PermissionResult;
  }
  return { kind: "allowed", scopes: user.role.scopes } satisfies PermissionResult;
};

const assertNever = (value: never): never => {
  throw new Error(`Unexpected value: ${JSON.stringify(value)}`);
};

const permissionLabel = (result: ReturnType<typeof evaluatePermission>) => {
  switch (result.kind) {
    case "allowed":
      return "Allowed";
    case "denied":
      return result.reason;
    default:
      return assertNever(result);
  }
};
```

If the project uses an inline exhaustive assignment instead, `const exhaustive: never = result` supplies the same compiler check. Decide separately whether unexpected runtime input should throw; a `never` annotation does not make that value disappear at runtime.

## Verified Semantic Primitives

Reuse the project's brand convention. A guard is safe only if its runtime check proves the domain constraint; the compiler trusts the predicate's declaration.

```ts
type AgentId = string & { readonly __brand: "AgentId" };

const isAgentId = (input: string): input is AgentId =>
  /^agent_[a-z0-9]+$/.test(input);

const parseAgentId = (input: unknown): AgentId => {
  if (typeof input !== "string" || !isAgentId(input)) {
    throw new Error("Expected an agent_ identifier with a nonempty lowercase alphanumeric suffix");
  }
  return input;
};

const focusAgent = (id: AgentId) => ({ focused: id });
const focused = focusAgent(parseAgentId("agent_42"));
```

When the repository already has a schema library, prefer its schema and inferred/branded output for a parsed object. A library's schema validation and TypeScript's `satisfies` check solve different problems.

## Total Collection Operations

An empty array is fine for a sum. A function requiring a first element can accept a nonempty tuple, or expose absence in its result instead.

```ts
type NonEmpty<T> = readonly [T, ...T[]];

const sum = (values: readonly number[]) =>
  values.reduce((total, value) => total + value, 0);

const isNonEmpty = <T>(values: readonly T[]): values is NonEmpty<T> =>
  values.length > 0;

const first = <T>(values: NonEmpty<T>): T => values[0];
const maybeFirst = <T>(values: readonly T[]): T | undefined => values[0];

const values: readonly string[] = ["newest", "older"];
const newest = isNonEmpty(values) ? first(values) : undefined;
```

`NonEmpty<T>` proves index zero exists. An arbitrary random index still requires a bound check or an honest possibly-undefined result, especially with `noUncheckedIndexedAccess`.

Likewise, a `number` duration alone accepts negative values, infinity, and NaN. Representing a range as start plus duration removes a stored relationship between two endpoints; validate the duration separately if the domain requires a finite nonnegative value.
