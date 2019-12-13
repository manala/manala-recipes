__metaclass__ = type

from ansible.errors import AnsibleAssertionError
from ansible.module_utils.six import string_types
from ansible.plugins.lookup import LookupBase

#from ansible.template import Templar

class KeyError(Exception):
    """Raised for unknown key."""
    def __init__(self, key):
        self.key = key

class LookupModule(LookupBase):

    def _get_nested(self, value, key, **kw):
        """
        Get a named key from an value; _get_nested(x, 'a.b.c.d') is equivalent
        to x['a']['b']['c']['d']. When a default keyword argument is given,
        it is returned when any attribute in the chain doesn't exist;
        without it, an exception is raised when a missing attribute is encountered.
        """

        if not isinstance(key, string_types):
            raise AnsibleAssertionError('nested key should be a string but was a %s' % type(key))

        keys = key.split('.')

        #templar = Templar(variables=value, loader=self._loader)

        for key in keys:
            if not isinstance(value, dict):
                raise AnsibleAssertionError('nested value should be a dict but was a %s' % type(value))
            if key in value:
                value = value.get(key)
                #value = templar.template(value.get(key), fail_on_undefined=False)
                #value = templar.template(value.get(key))
            else:
                if kw.has_key('default'):
                    return kw['default']
                else:
                    raise KeyError(key)
        return value

    def run(self, terms, variables, **kwargs):

        key = terms[0]
        hashes = terms[1]

        candidates = []

        #templar = Templar(variables=variables, loader=self._loader)

        for hash_key in hashes:
            try:
                hash = self._get_nested(variables, hash_key)
                #hash = templar.template(self._get_nested(variables, hash_key), fail_on_undefined=False)
                #hash = templar.template(self._get_nested(variables, hash_key))
                if not isinstance(hash, dict):
                    raise AnsibleAssertionError('hash "%s" should be a dict but was a %s' % (hash_key, type(hash)))
                candidates.append(self._get_nested(hash, key))
            except KeyError:
                pass

        if not len(candidates):
            if kwargs.has_key('default'):
                return kwargs['default']
            else:
                raise AnsibleAssertionError('no candidates for merging key "%s"' % key)

        ret = None

        for candidate in candidates:
            if type(candidate) != type(ret):
                ret = candidate
            else:
                if isinstance(candidate, dict):
                    ret.update(candidate)
                elif isinstance(candidate, list):
                    ret += candidate
                else:
                    ret = candidate

        return ret
